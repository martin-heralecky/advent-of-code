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
	local double_cave=$2

	if [ $cur = "end" ]; then
		paths=$((paths + 1))
		return 0
	fi

	local small_caves=("${@:3}")
	if [[ "${cur}" =~ [a-z] ]]; then
		duplicate_cave=0
		for c in ${small_caves[@]}; do
			if [ $c = $cur ]; then
				duplicate_cave=1
				break
			fi
		done

		if [ $duplicate_cave -eq 1 ]; then
			if [ $double_cave -eq 0 -a $cur != "start" ]; then
				double_cave=1
			else
				return 0
			fi
		fi

		small_caves+=($cur)
	fi

	for p in ${links["$cur"]}; do
		search $p $double_cave ${small_caves[@]}
	done
}

search "start" 0

echo $paths
