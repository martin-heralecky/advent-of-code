#!/bin/bash

set -e

declare -A links
while read l; do
	left=$(echo "$l" | awk -F '-' '{print $1}')
	right=$(echo "$l" | awk -F '-' '{print $2}')

	if [ ! "${links["$left"]}" ]; then
		links["$left"]="$right"
	else
		links["$left"]="${links["$left"]} $right"
	fi

	if [ ! "${links["$right"]}" ]; then
		links["$right"]="$left"
	else
		links["$right"]="${links["$right"]} $left"
	fi
done < input.txt

paths=0

function search {
	local cur=$1

	if [ $cur = "end" ]; then
		paths=$((paths + 1))
		return 0
	fi

	local small_caves=("${@:2}")
	if [[ "${cur}" =~ [a-z] ]]; then
		for c in ${small_caves[@]}; do
			if [ $c = $cur ]; then
				return 0
			fi
		done

		small_caves+=($cur)
	fi

	for p in ${links["$cur"]}; do
		search $p ${small_caves[@]}
	done
}

search "start"

echo $paths
