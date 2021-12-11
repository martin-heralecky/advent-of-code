#!/bin/bash

set -e

map=($(cat input.txt | grep -o . | tr '\n' ' '))
function get { echo ${map[$(($2 * 10 + $1))]}; }
function _set { map[$(($2 * 10 + $1))]=$3; }

function inc {
	if [ $(get $1 $2) != f ]; then
		map[$(($2 * 10 + $1))]=$((map[$2 * 10 + $1] + 1))

		if [ $(get $1 $2) -ge 10 ]; then
			flash $1 $2
		fi
	fi
}

function flash {
	local x=$1
	local y=$2

	_set $x $y f

	if [ $y -gt 0 ]; then
		inc $x $((y-1))
		if [ $x -gt 0 ]; then
			inc $((x-1)) $((y-1))
		fi
	fi
	if [ $x -gt 0 ]; then
		inc $((x-1)) $y
		if [ $y -lt 9 ]; then
			inc $((x-1)) $((y+1))
		fi
	fi
	if [ $y -lt 9 ]; then
		inc $x $((y+1))
		if [ $x -lt 9 ]; then
			inc $((x+1)) $((y+1))
		fi
	fi
	if [ $x -lt 9 ]; then
		inc $((x+1)) $y
		if [ $y -gt 0 ]; then
			inc $((x+1)) $((y-1))
		fi
	fi
}

function _print {
	echo ${map[@]} | grep -oP '([^ ]+ ){9}[^ ]+'
}

step=1
while true; do
	for i in {0..99}; do
		map[$i]=$((map[$i] + 1))
	done

	for y in {0..9}; do
		for x in {0..9}; do
			if [ $(get $x $y) = "10" ]; then
				flash $x $y
			fi
		done
	done

	flashes=0
	for y in {0..9}; do
		for x in {0..9}; do
			if [ $(get $x $y) = f ]; then
				_set $x $y 0
				flashes=$((flashes + 1))
			fi
		done
	done

	if [ $flashes -eq 100 ]; then
		echo $step
		break
	fi

	step=$((step + 1))
done
