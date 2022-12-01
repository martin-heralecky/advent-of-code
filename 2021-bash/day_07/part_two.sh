#!/bin/bash

set -e

min=$(cat input.txt | tr , '\n' | sort -n | head -n 1)
max=$(cat input.txt | tr , '\n' | sort -nr | head -n 1)

echo "Will try positions in range [$min,$max]."

min_fuel=999999999
for i in $(seq $min $max); do
	echo -n "pos $i: "

	fuel_sum=0

	while read l; do
		distance=$((l - i))
		if [ $distance -lt 0 ]; then
			distance=$((-distance))
		fi

		fuel=$(((distance * (1 + distance)) / 2))
		fuel_sum=$((fuel_sum + fuel))
	done <<< "$(cat input.txt | tr , '\n')"

	echo -n "$fuel_sum fuel "

	if [ $fuel_sum -lt $min_fuel ]; then
		min_fuel=$fuel_sum
		echo -n "new min"
	fi

	echo
done

echo $min_fuel
