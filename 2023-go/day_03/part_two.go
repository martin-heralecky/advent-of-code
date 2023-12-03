package main

import (
	"fmt"
	"os"
)

const size = 140

var schema [][]byte

func main() {
	file, _ := os.Open("input.txt")

	schema = make([][]byte, size)
	for i := 0; i < size; i++ {
		schema[i] = make([]byte, size)
		_, _ = file.Read(schema[i])
		_, _ = file.Seek(1, 1)
	}

	gears := make(map[[2]int][]int)

	gearsCur := make(map[[2]int]bool)
	val := 0

	for y, row := range schema {
		for x, c := range row {
			if c >= '0' && c <= '9' {
				val = val*10 + int(c-'0')
				for _, gear := range getGears(x, y) {
					gearsCur[gear] = true
				}
			} else {
				for gear := range gearsCur {
					gears[gear] = append(gears[gear], val)
				}

				gearsCur = make(map[[2]int]bool)
				val = 0
			}
		}
	}

	res := 0
	for _, parts := range gears {
		if len(parts) == 2 {
			res += parts[0] * parts[1]
		}
	}

	fmt.Println(res)
}

func getGears(x int, y int) [][2]int {
	edges := [][2]int{
		{-1, -1},
		{-1, 0},
		{-1, 1},
		{0, -1},
		{0, 0},
		{0, 1},
		{1, -1},
		{1, 0},
		{1, 1},
	}

	res := make([][2]int, 0)

	for _, edge := range edges {
		_x := x + edge[0]
		_y := y + edge[1]
		if _x >= 0 && _x < size && _y >= 0 && _y < size && schema[_y][_x] == '*' {
			res = append(res, [2]int{_x, _y})
		}
	}

	return res
}
