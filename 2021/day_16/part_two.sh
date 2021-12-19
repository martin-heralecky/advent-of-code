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

function read_packet {
	read_packet_res=""

	local version=${str:cur:3}
	((cur += 3))

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

		read_packet_res=$(bin2dec $value)
		>&2 echo "literal: $read_packet_res"
	else
		# not literal
		local values=()

		local length_type=${str:cur:1}
		((cur += 1))

		if [ $length_type -eq 0 ]; then
			local total_length=$(bin2dec ${str:cur:15})
			((cur += 15))

			local end=$((cur + total_length))
			while [ $cur -lt $end ]; do
				read_packet
				values+=($read_packet_res)
			done
		else
			local subp_num=$(bin2dec ${str:cur:11})
			((cur += 11))

			for i in $(seq $subp_num); do
				read_packet
				values+=($read_packet_res)
			done
		fi

		case $type in
			000)
				>&2 echo "sum: ${values[@]}"
				read_packet_res=$(echo "${values[@]}" | tr ' ' + | bc)
				;;
			001)
				>&2 echo "product: ${values[@]}"
				read_packet_res=$(echo "${values[@]}" | tr ' ' '*' | bc)
				;;
			010)
				>&2 echo "min: ${values[@]}"
				read_packet_res=$(echo "${values[@]}" | tr ' ' '\n' | sort -n | head -n1)
				;;
			011)
				>&2 echo "max: ${values[@]}"
				read_packet_res=$(echo "${values[@]}" | tr ' ' '\n' | sort -nr | head -n1)
				;;
			101)
				>&2 echo "gt: ${values[@]}"
				if [ ${values[0]} -gt ${values[1]} ]; then read_packet_res=1; else read_packet_res=0; fi
				;;
			110)
				>&2 echo "lt: ${values[@]}"
				if [ ${values[0]} -lt ${values[1]} ]; then read_packet_res=1; else read_packet_res=0; fi
				;;
			111)
				>&2 echo "eq: ${values[@]}"
				if [ ${values[0]} -eq ${values[1]} ]; then read_packet_res=1; else read_packet_res=0; fi
				;;
			*)
				>&2 echo "invalid type: $type"
				read_packet_res=0
		esac
	fi
}

read_packet
echo $read_packet_res
