#!/bin/bash

set -e

declare -A rules
while read l; do
	rules[${l:0:2}]=${l:6}
done <<<"$(sed -n '/^$/,${/./p}' input.txt)"

template=$(head -n1 input.txt)

for j in {0..9}; do
	polymer=""
	for i in $(seq 0 $(($(echo -n $template | wc -c) - 2))); do
		polymer="${polymer}${template:i:1}"

		insert="${rules[${template:i:2}]}"
		if [ ! -z "$insert" ]; then
			polymer="${polymer}${rules[${template:i:2}]}"
		fi
	done
	polymer="${polymer}${template: -1}"

	template=$polymer
done

stats="$(echo $polymer | grep -o '.' | sort | uniq -c | sort -n | grep -oP '[0-9]*')"
echo $(($(echo "$stats" | tail -n1) - $(echo "$stats" | head -n1)))
