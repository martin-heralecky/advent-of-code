#!/bin/bash

set -e

map=($(cat input.txt | grep -o . | tr '\n' ' '))

function search {
	local x=$1
	local y=$2

	local cur=${map[$(($y * 100 + $x))]}
	if [ $cur -eq 9 ]; then return 0; fi

	basin_size=$((basin_size + 1))
	map[$(($y * 100 + $x))]=9

	if [ $y -gt 0  ]; then search $x $((y-1)); fi
	if [ $x -lt 99 ]; then search $((x+1)) $y; fi
	if [ $y -lt 99 ]; then search $x $((y+1)); fi
	if [ $x -gt 0  ]; then search $((x-1)) $y; fi
}

basins=""
for y in {0..99}; do
	for x in {0..99}; do
		basin_size=0
		search $x $y
		[ $basin_size -gt 0 ] && basins="$basins $basin_size"
	done
done

echo $basins | tr ' ' '\n' | sort -n | tail -n 3 | tr '\n' '*' | sed 's/\*$/\n/' | bc
