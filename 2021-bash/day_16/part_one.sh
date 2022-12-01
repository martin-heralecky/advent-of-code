#!/bin/bash

set -e

function hex2bin {
	printf "%$((${#1} * 4))s" "$(echo "obase=2; ibase=16; $1" | BC_LINE_LENGTH=0 bc)" | tr ' ' 0
}

function bin2dec {
	echo "obase=10; ibase=2; $1" | BC_LINE_LENGTH=0 bc
}

str=$(hex2bin $(cat input.txt))
cur=0

version_sum=0

function read_packet {
	local version=${str:cur:3}
	((cur += 3))
	((version_sum += $(bin2dec $version)))

	local type=${str:cur:3}
	((cur += 3))

	if [ $type = 100 ]; then
		# literal
		local value=""

		local prefix=1
		while [ $prefix -ne 0 ]; do
			prefix=${str:cur:1}
			((cur += 1))

			value+=${str:cur:4}
			((cur += 4))
		done
	else
		# not literal
		local length_type=${str:cur:1}
		((cur += 1))

		if [ $length_type -eq 0 ]; then
			local total_length=$(bin2dec ${str:cur:15})
			((cur += 15))

			local end=$((cur + total_length))
			while [ $cur -lt $end ]; do
				read_packet
			done
		else
			local subp_num=$(bin2dec ${str:cur:11})
			((cur += 11))

			for i in $(seq $subp_num); do
				read_packet
			done
		fi
	fi
}

read_packet

echo $version_sum
