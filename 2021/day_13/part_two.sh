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

function fold_y {
	local fold=$1

	for y in $(seq $((fold + 1)) $((height - 1))); do
		for x in $(seq 0 $((width - 1))); do
			if [ "${paper[$((y * orig_width + x))]}" = "#" ]; then
				paper[$(((fold - (y - fold)) * orig_width + x))]="#"
			fi
		done
	done

	height=$fold
}

while read l; do
	if [ ${l:0:1} = "x" ]; then
		fold_x ${l:2}
	else
		fold_y ${l:2}
	fi
done <<<"$(sed -n '/^$/,${/./p}' input.txt | cut -c 12-)"

for y in $(seq 0 $((height - 1))); do
	for x in $(seq 0 $((width - 1))); do
		if [ ! -z "${paper[$((y * orig_width + x))]}" ]; then
			echo -n "#"
		else
			echo -n " "
		fi
	done

	echo
done
