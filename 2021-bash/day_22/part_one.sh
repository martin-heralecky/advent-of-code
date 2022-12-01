#!/bin/bash

declare -A reactor
for z in {-50..50}; do
	for y in {-50..50}; do
		for x in {-50..50}; do
			reactor[$x-$y-$z]=0
		done
	done
done

while read l; do
	if [ "$(echo "$l" | grep -oP '^[^ ]+')" = "on" ]; then
		state=1
	else
		state=0
	fi

	x="$(echo "$l" | grep -oP '(?<=x=)\-?\d+\.\.\-?\d+')"
	y="$(echo "$l" | grep -oP '(?<=y=)\-?\d+\.\.\-?\d+')"
	z="$(echo "$l" | grep -oP '(?<=z=)\-?\d+\.\.\-?\d+')"

	x1="$(echo "$x" | grep -oP '^\-?\d+')"
	x2="$(echo "$x" | grep -oP '\-?\d+$')"
	y1="$(echo "$y" | grep -oP '^\-?\d+')"
	y2="$(echo "$y" | grep -oP '\-?\d+$')"
	z1="$(echo "$z" | grep -oP '^\-?\d+')"
	z2="$(echo "$z" | grep -oP '\-?\d+$')"

	echo -n "step: [$x1,$y1,$z1] - [$x2,$y2,$z2] ($(((x2-x1) * (y2-y1) * (z2-z1)))) "

	for z in $(seq $z1 $z2); do
		for y in $(seq $y1 $y2); do
			for x in $(seq $x1 $x2); do
				reactor[$x-$y-$z]=$state
			done
		done
	done

	echo "done"
done <<<"$(head -n 20 input.txt)"

echo "${reactor[@]}" | tr ' ' '\n' | grep 1 | wc -l
