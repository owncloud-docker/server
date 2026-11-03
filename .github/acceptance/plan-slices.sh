#!/usr/bin/env bash
# Pack ownCloud core's acceptance suites into slices that take about equally
# long, by the minutes in suite-minutes.tsv, for the matrix of the tests job.
# run.sh --part can't do this: it splits the suites by count, not duration.
#
# usage: plan-slices.sh <suites> <mode> <target> <api-tags> <cli-tags>
#   suites    file listing one suite per line, e.g. apiMain
#   mode      smoke or full, the column of suite-minutes.tsv to use
#   target    minutes a slice should take, unless one suite alone takes longer
#   api-tags  Behat tag filter for the api suites
#   cli-tags  Behat tag filter for the cli suites
#
# Prints the matrix as JSON: [{type, slice, slices, suites, tags, minutes}],
# where suites is the comma-separated list for run.sh --suites.
set -euo pipefail

suites=$1 mode=$2 target=$3 api_tags=$4 cli_tags=$5
table="$(dirname "$0")/suite-minutes.tsv"
case "${mode}" in
  smoke) column=2 default=3 ;;
  full) column=3 default=20 ;;
  *) echo "unknown mode ${mode}" >&2 && exit 1 ;;
esac

# "suite<TAB>minutes" for every suite to run. A suite the table doesn't know yet
# still runs, with a default duration that is easy to spot in the plan.
weights=$(awk -F'\t' -v column="${column}" -v fallback="${default}" '
  NR == FNR { if (!/^#/ && NF) minutes[$1] = $column; next }
  NF {
    if (!($1 in minutes)) {
      printf "::warning::suite %s is not in suite-minutes.tsv, assuming %s minutes\n", $1, fallback > "/dev/stderr"
      minutes[$1] = fallback
    }
    print $1 "\t" minutes[$1]
  }' "${table}" "${suites}")
[[ -n "${weights}" ]] || { echo "no suites in ${suites}" >&2 && exit 1; }

# Longest suite first, each into the slice with the fewest minutes so far.
matrix=$(jq -Rnc --argjson target "${target}" --arg api "${api_tags}" --arg cli "${cli_tags}" '
  [inputs | split("\t") | {suite: .[0], minutes: (.[1] | tonumber), type: (.[0] | capture("^(?<t>api|cli)").t)}]
  | group_by(.type)
  | map(
      .[0].type as $type
      | ([1, ((map(.minutes) | add) / $target | ceil)] | max) as $n
      | reduce (sort_by(-.minutes, .suite) | .[]) as $s ([range($n) | {suites: [], minutes: 0}];
          (to_entries | min_by(.value.minutes).key) as $i
          | .[$i].suites += [$s.suite] | .[$i].minutes += $s.minutes)
      | to_entries
      | map({type: $type, slice: (.key + 1), slices: $n, suites: (.value.suites | sort | join(",")),
          tags: (if $type == "api" then $api else $cli end), minutes: (.value.minutes * 10 | round / 10)}))
  | flatten' <<<"${weights}")

# every suite in exactly one slice
planned=$(jq -r '.[].suites | split(",")[]' <<<"${matrix}" | sort)
[[ "${planned}" == "$(cut -f1 <<<"${weights}" | sort -u)" ]] || {
  echo "the slices don't run every suite exactly once" >&2 && exit 1
}

jq -r '.[] | "\(.type) \(.slice)/\(.slices): \(.minutes) min, \(.suites)"' <<<"${matrix}" >&2
echo "${matrix}"
