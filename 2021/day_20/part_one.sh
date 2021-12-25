#!/bin/bash

steps=$1
if [ -z "$steps" ]; then steps=2; fi

algo=($(head -n1 input.txt | tr '#.' '10' | sed 's/./& /g'))

def_state=0

declare -A img new_img
y=0
while read l; do
	for x in {0..99}; do
		img[$x-$y]=${l:x:1}
	done

	(( y++ ))
done <<<"$(tail -n100 input.txt | tr '#.' '10')"

function enhance {
	local x=$1
	local y=$2

	local index=0
	local pixel=""

	pixel=${img[$((x-1))-$((y-1))]}
	if [ -z "$pixel" ]; then pixel=$def_state; fi
	(( index += 256 * $pixel ))
	pixel=${img[$((x-0))-$((y-1))]}
	if [ -z "$pixel" ]; then pixel=$def_state; fi
	(( index += 128 * $pixel ))
	pixel=${img[$((x+1))-$((y-1))]}
	if [ -z "$pixel" ]; then pixel=$def_state; fi
	(( index +=  64 * $pixel ))
	pixel=${img[$((x-1))-$((y-0))]}
	if [ -z "$pixel" ]; then pixel=$def_state; fi
	(( index +=  32 * $pixel ))
	pixel=${img[$((x-0))-$((y-0))]}
	if [ -z "$pixel" ]; then pixel=$def_state; fi
	(( index +=  16 * $pixel ))
	pixel=${img[$((x+1))-$((y-0))]}
	if [ -z "$pixel" ]; then pixel=$def_state; fi
	(( index +=   8 * $pixel ))
	pixel=${img[$((x-1))-$((y+1))]}
	if [ -z "$pixel" ]; then pixel=$def_state; fi
	(( index +=   4 * $pixel ))
	pixel=${img[$((x-0))-$((y+1))]}
	if [ -z "$pixel" ]; then pixel=$def_state; fi
	(( index +=   2 * $pixel ))
	pixel=${img[$((x+1))-$((y+1))]}
	if [ -z "$pixel" ]; then pixel=$def_state; fi
	(( index +=   1 * $pixel ))

	new_img[$x-$y]=${algo[$index]}
}

for i in $(seq 1 $steps); do
	echo -n "step $i: "

	for y in $(seq $((0 - i)) $((99 + i))); do
		for x in $(seq $((0 - i)) $((99 + i))); do
			enhance $x $y
		done
	done

	for y in $(seq $((0 - i)) $((99 + i))); do
		for x in $(seq $((0 - i)) $((99 + i))); do
			img[$x-$y]=${new_img[$x-$y]}
		done
	done

	if [ $def_state -eq 0 ]; then
		def_state=1
	else
		def_state=0
	fi

	echo "done"
done

echo "${img[@]}" | tr ' ' '\n' | grep 1 | wc -l
