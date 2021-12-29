#!/bin/bash

# these never overlap
cuboids=()

while read l; do
	if [ "$(echo "$l" | grep -oP '^[^ ]+')" = "on" ]; then
		state=1
	else
		state=0
	fi

	x="$(echo "$l" | grep -oP '(?<=x=)\-?\d+\.\.\-?\d+')"
	y="$(echo "$l" | grep -oP '(?<=y=)\-?\d+\.\.\-?\d+')"
	z="$(echo "$l" | grep -oP '(?<=z=)\-?\d+\.\.\-?\d+')"

	x1="$(echo "$x" | grep -oP '^\-?\d+')"
	x2="$(echo "$x" | grep -oP '\-?\d+$')"
	y1="$(echo "$y" | grep -oP '^\-?\d+')"
	y2="$(echo "$y" | grep -oP '\-?\d+$')"
	z1="$(echo "$z" | grep -oP '^\-?\d+')"
	z2="$(echo "$z" | grep -oP '\-?\d+$')"

	echo -n "step: [$x1,$y1,$z1] - [$x2,$y2,$z2] ${#cuboids[@]} "

	i=0
	while [ $i -lt ${#cuboids[@]} ]; do
		read cx1 cy1 cz1 cx2 cy2 cz2 <<< "${cuboids[$i]}"

		if [ $x1 -le $cx2 -a $x2 -ge $cx1 -a $y1 -le $cy2 -a $y2 -ge $cy1 -a $z1 -le $cz2 -a $z2 -ge $cz1 ]; then
			if [ $x1 -gt $cx1 -a $x1 -le $cx2 ]; then
				cuboids[$i]="$cx1 $cy1 $cz1 $((x1 - 1)) $cy2 $cz2"
				cuboids+=("$x1 $cy1 $cz1 $cx2 $cy2 $cz2")
			elif [ $x2 -ge $cx1 -a $x2 -lt $cx2 ]; then
				cuboids[$i]="$((x2 + 1)) $cy1 $cz1 $cx2 $cy2 $cz2"
				cuboids+=("$cx1 $cy1 $cz1 $x2 $cy2 $cz2")
			elif [ $y1 -gt $cy1 -a $y1 -le $cy2 ]; then
				cuboids[$i]="$cx1 $cy1 $cz1 $cx2 $((y1 - 1)) $cz2"
				cuboids+=("$cx1 $y1 $cz1 $cx2 $cy2 $cz2")
			elif [ $y2 -ge $cy1 -a $y2 -lt $cy2 ]; then
				cuboids[$i]="$cx1 $((y2 + 1)) $cz1 $cx2 $cy2 $cz2"
				cuboids+=("$cx1 $cy1 $cz1 $cx2 $y2 $cz2")
			elif [ $z1 -gt $cz1 -a $z1 -le $cz2 ]; then
				cuboids[$i]="$cx1 $cy1 $cz1 $cx2 $cy2 $((z1 - 1))"
				cuboids+=("$cx1 $cy1 $z1 $cx2 $cy2 $cz2")
			elif [ $z2 -ge $cz1 -a $z2 -lt $cz2 ]; then
				cuboids[$i]="$cx1 $cy1 $((z2 + 1)) $cx2 $cy2 $cz2"
				cuboids+=("$cx1 $cy1 $cz1 $cx2 $cy2 $z2")
			else
				# delete c
				cuboids[$i]="${cuboids[-1]}"
				unset cuboids[-1]
				(( --i ))
			fi
		fi

		(( ++i ))
	done

	if [ $state -eq 1 ]; then
		cuboids+=("$x1 $y1 $z1 $x2 $y2 $z2")
	fi

	echo "done"
done < input.txt

cubes=0
for c in "${cuboids[@]}"; do
	read x1 y1 z1 x2 y2 z2 <<< "$c"
	(( cubes += (x2-x1+1) * (y2-y1+1) * (z2-z1+1) ))
done
echo $cubes
