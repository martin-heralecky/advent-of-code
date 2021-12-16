#!/bin/bash

set -e

paper=()

orig_width=$(($(sed '/^$/,$d' input.txt | cut -f1 -d, | sort -nr | head -n1) + 1))
orig_height=$(($(sed '/^$/,$d' input.txt | cut -f2 -d, | sort -nr | head -n1) + 1))
width=$orig_width
height=$orig_height

while read l; do
	paper[$((${l#*,} * width + ${l%,*}))]="#"
done <<<"$(sed '/^$/,$d' input.txt)"

function fold_x {
	local fold=$1

	for y in $(seq 0 $((height - 1))); do
		for x in $(seq $((fold + 1)) $((width - 1))); do
			if [ "${paper[$((y * orig_width + x))]}" = "#" ]; then
				paper[$((y * orig_width + (fold - (x - fold))))]="#"
			fi
		done
	done

	width=$fold
}

fold_x 655

dots=0
for y in $(seq 0 $((height - 1))); do
	for x in $(seq 0 $((width - 1))); do
		if [ ! -z "${paper[$((y * orig_width + x))]}" ]; then
			((dots+=1))
		fi
	done
done
echo $dots
