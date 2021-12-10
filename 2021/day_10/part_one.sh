#!/bin/bash

set -e

buf=()
function push { buf+=("$1"); }
function pop { unset buf[-1]; }
function last { echo "${buf[-1]}"; }
function empty { [ ${#buf[@]} -eq 0 ]; }
function closing {
	if [ "$1" = "(" ]; then echo -n ")"
	elif [ "$1" = "[" ]; then echo -n "]"
	elif [ "$1" = "{" ]; then echo -n "}"
	elif [ "$1" = "<" ]; then echo -n ">"
	fi
}
function error {
	if [ "$1" = ")" ]; then score=$((score + 3))
	elif [ "$1" = "]" ]; then score=$((score + 57))
	elif [ "$1" = "}" ]; then score=$((score + 1197))
	elif [ "$1" = ">" ]; then score=$((score + 25137))
	fi
}

score=0
while read l; do
	while read -n1 c; do
		if [ "$c" = "(" ] || [ "$c" = "[" ] || [ "$c" = "{" ] || [ "$c" = "<" ]; then
			push "$c"
		elif [ "$c" = "$(closing "$(last)")" ]; then
			pop
		else
			error "$c"
			break
		fi
	done < <(echo -n "$l")

	buf=()
done < input.txt
echo $score
