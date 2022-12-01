#!/bin/bash


width=$(( $(head -n1 input.txt | wc -c) - 1 ))
height=$(cat input.txt | wc -l)

map=($(grep -o . input.txt))

function _print {
	clear
	for y in $(seq 0 $((height - 1))); do
		for x in $(seq 0 $((width - 1))); do
			echo -n "${map[$((y * width + x))]}"
		done
		echo
	done
}

step=1
while true; do
	echo -n "step $step: "

	moved=0

	first_col=()
	for y in $(seq 0 $((height - 1))); do
		first_col[$y]=${map[$((y * width))]}
	done

	# >
	y=0
	while [ $y -lt $height ]; do
		x=0
		while [ $x -lt $width ]; do
			if [ "${map[$((y * width + x))]}" = ">" ]; then
				if [ $x -eq $((width - 1)) ]; then
					if [ "${first_col[$y]}" = "." ]; then
						map[$((y * width + x))]="."
						map[$((y * width))]=">"
						(( ++moved))
					fi
				elif [ "${map[$((y * width + x + 1))]}" = "." ]; then
					map[$((y * width + x))]="."
					map[$((y * width + x + 1))]=">"
					(( ++moved))
					(( ++x ))
				fi
			fi

			(( ++x ))
		done

		(( ++y ))
	done

	first_row=()
	for x in $(seq 0 $((width - 1))); do
		first_row[$x]=${map[$x]}
	done

	# v
	x=0
	while [ $x -lt $width ]; do
		y=0
		while [ $y -lt $height ]; do
			if [ "${map[$((y * width + x))]}" = "v" ]; then
				if [ $y -eq $((height - 1)) ]; then
					if [ "${first_row[$x]}" = "." ]; then
						map[$((y * width + x))]="."
						map[$x]="v"
						(( ++moved))
					fi
				elif [ "${map[$(((y + 1) * width + x))]}" = "." ]; then
					map[$((y * width + x))]="."
					map[$(((y + 1) * width + x))]="v"
					(( ++moved))
					(( ++y ))
				fi
			fi

			(( ++y ))
		done

		(( ++x ))
	done

	echo "moved $moved"
	if [ $moved -eq 0 ]; then
		echo $step
		break
	fi

	(( ++step ))
done
