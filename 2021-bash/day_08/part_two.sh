#!/bin/bash

set -e

function sort_chars {
	echo "$1" | xargs -I{} bash -c 'echo {} | grep -o . | sort | tr -d "\n" && echo'
}

res=0
while read l; do
	digits="$(echo "$l" | cut -c -58 | tr ' ' '\n')"
	output="$(echo "$l" | cut -c 62- | tr ' ' '\n')"

	digits_sorted="$(sort_chars "$digits")"
	output_sorted="$(sort_chars "$output")"

	digits_sorted_by_size="$(echo "$digits_sorted" | xargs -I{} bash -c 'echo -n "{} " && echo -n {} | wc -c' | sort -k2 | grep -oP '^[^ ]*')"

	one="$(echo "$digits_sorted_by_size" | head -n1)"
	seven="$(echo "$digits_sorted_by_size" | head -n2 | tail -n1)"
	four="$(echo "$digits_sorted_by_size" | head -n3 | tail -n1)"
	two_three_five="$(echo "$digits_sorted_by_size" | head -n6 | tail -n3)"
	zero_six_nine="$(echo "$digits_sorted_by_size" | head -n9 | tail -n3)"
	eight="$(echo "$digits_sorted_by_size" | tail -n1)"

	three="$(echo "$two_three_five" | grep ${one:0:1} | grep ${one:1:1})"
	two_five="$(echo "$two_three_five" | grep -v $three)"

	four_minus_one="$(echo $four | grep -o . | grep -v ${one:0:1} | grep -v ${one:1:1} | tr -d '\n')"
	five="$(echo "$two_five" | grep ${four_minus_one:0:1} | grep ${four_minus_one:1:1})"
	two="$(echo "$two_five" | grep -v $five)"

	nine="$(echo "$zero_six_nine" | grep ${four:0:1} | grep ${four:1:1} | grep ${four:2:1} | grep ${four:3:1})"
	zero_six="$(echo "$zero_six_nine" | grep -v $nine)"

	zero="$(echo "$zero_six" | grep ${one:0:1} | grep ${one:1:1})"
	six="$(echo "$zero_six" | grep -v $zero)"

	val=$(echo "$output_sorted" |
		sed "s/^$zero\$/0/" |
		sed "s/^$one\$/1/" |
		sed "s/^$two\$/2/" |
		sed "s/^$three\$/3/" |
		sed "s/^$four\$/4/" |
		sed "s/^$five\$/5/" |
		sed "s/^$six\$/6/" |
		sed "s/^$seven\$/7/" |
		sed "s/^$eight\$/8/" |
		sed "s/^$nine\$/9/" |
		tr -d '\n' |
		sed 's/^0*//')

	res=$((res+val))
done < input.txt

echo $res
