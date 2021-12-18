#!/bin/bash

set -e

declare -A rules cache
while read l; do
	rules[${l:0:2}]=${l:6}
done <<<"$(sed -n '/^$/,${/./p}' input.txt)"

function get_zero_stats {
	echo "0 0 0 0 0 0 0 0 0 0"
}

function merge_stats {
	echo "$((${1}+${11})) $((${2}+${12})) $((${3}+${13})) $((${4}+${14})) $((${5}+${15})) $((${6}+${16})) $((${7}+${17})) $((${8}+${18})) $((${9}+${19})) $((${10}+${20}))"
}

function inc_stats_part {
	local _1=${1}
	local _2=${2}
	local _3=${3}
	local _4=${4}
	local _5=${5}
	local _6=${6}
	local _7=${7}
	local _8=${8}
	local _9=${9}
	local _10=${10}

	case ${11} in
		B)
			((_1 += 1))
			;;
		C)
			((_2 += 1))
			;;
		F)
			((_3 += 1))
			;;
		H)
			((_4 += 1))
			;;
		K)
			((_5 += 1))
			;;
		N)
			((_6 += 1))
			;;
		O)
			((_7 += 1))
			;;
		P)
			((_8 += 1))
			;;
		S)
			((_9 += 1))
			;;
		V)
			((_10 += 1))
			;;
	esac

	echo "$_1 $_2 $_3 $_4 $_5 $_6 $_7 $_8 $_9 $_10"
}

get_stats_res=""
function get_stats {
	local depth=$1
	local pair=$2
	local cache_id="${pair}${depth}"
	local stats=""

	if [ -z "${cache[$cache_id]}" ]; then
		if [ $depth -lt 40 ]; then
			local left_subpair="${pair:0:1}${rules[$pair]}"
			local right_subpair="${rules[$pair]}${pair:1:1}"
			local subdepth=$((depth + 1))

			get_stats $subdepth $left_subpair
			local left_stats="$get_stats_res"
			get_stats $subdepth $right_subpair
			local right_stats="$get_stats_res"

			stats="$(merge_stats $left_stats $right_stats)"
		else
			stats="$(inc_stats_part $(get_zero_stats) ${pair:0:1})"
		fi

		cache[$cache_id]="$stats"
	fi

	get_stats_res="${cache[$cache_id]}"
}

stats="$(get_zero_stats)"
template=$(head -n1 input.txt)
for i in $(seq 0 $(($(echo -n $template | wc -c) - 2))); do
	get_stats 0 ${template:i:2}
	stats="$(merge_stats $stats $get_stats_res)"
done
stats="$(inc_stats_part $stats ${template: -1})"

vals="$(echo $stats | tr ' ' '\n' | sort -n)"
echo $(($(echo "$vals" | tail -n1) - $(echo "$vals" | head -n1)))
