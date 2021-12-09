#!/bin/bash

set -e

map="$(cat input.txt | tr -d '\n')"

function get {
	echo ${map:$(($2 * 100 + $1)):1}
}

risk=0
for y in {0..99}; do
	for x in {0..99}; do
		cur=$(get $x $y)

		[ $y -gt 0 ]  && [ $(get $x $((y-1))) -le $cur ] && continue
		[ $x -gt 0 ]  && [ $(get $((x-1)) $y) -le $cur ] && continue
		[ $y -lt 99 ] && [ $(get $x $((y+1))) -le $cur ] && continue
		[ $x -lt 99 ] && [ $(get $((x+1)) $y) -le $cur ] && continue

		risk=$((risk + cur + 1))
	done
done

echo $risk
