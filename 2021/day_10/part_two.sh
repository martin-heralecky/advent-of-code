#!/bin/bash

set -e

function push { buf+=("$1"); }
function pop { unset buf[-1]; }
function last { echo "${buf[-1]}"; }
function closing {
	if [ "$1" = "(" ]; then echo -n ")"
	elif [ "$1" = "[" ]; then echo -n "]"
	elif [ "$1" = "{" ]; then echo -n "}"
	elif [ "$1" = "<" ]; then echo -n ">"
	fi
}

scores=()
while read l; do
	buf=()
	error=0

	while read -n1 c; do
		if [ "$c" = "(" ] || [ "$c" = "[" ] || [ "$c" = "{" ] || [ "$c" = "<" ]; then
			push "$c"
		elif [ "$c" = "$(closing "$(last)")" ]; then
			pop
		else
			error=1
			break
		fi
	done < <(echo -n "$l")

	if [ $error -eq 1 ]; then
		continue
	fi

	if [ ${#buf[@]} -eq 0 ]; then
		continue
	fi

	score=0
	for i in $(seq 0 $((${#buf[@]} - 1)) | sort -nr); do
		score=$((score * 5))
		if [ "${buf[i]}" = "(" ]; then score=$((score + 1))
		elif [ "${buf[i]}" = "[" ]; then score=$((score + 2))
		elif [ "${buf[i]}" = "{" ]; then score=$((score + 3))
		elif [ "${buf[i]}" = "<" ]; then score=$((score + 4))
		fi
	done
	scores+=($score)
done < input.txt

scores="$(echo ${scores[@]} | tr ' ' '\n' | sort -n)"
echo "$scores" | head -n $(($(echo "$scores" | wc -l) / 2 + 1)) | tail -n1
