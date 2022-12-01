#!/bin/bash

set -e

num="$1"
if [ -z "$num" ]; then num=80; fi

fish=(0 0 0 0 0 0 0 0 0)
while read l; do
	fish[$(echo $l | awk '{print $2}')]=$(echo $l | awk '{print $1}')
done <<< "$(cat input.txt | tr ',' '\n' | sort | uniq -c)"

for i in $(seq 0 $((num - 1))); do
	repr_fish=${fish[0]}
	fish=(${fish[@]:1})
	fish[6]=$((fish[6] + repr_fish))
	fish[8]=$repr_fish
done

echo ${fish[@]} | tr ' ' + | bc
