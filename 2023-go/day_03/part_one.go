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

	res := 0

	isPart := false
	val := 0

	for y, row := range schema {
		for x, c := range row {
			if c >= '0' && c <= '9' {
				val = val*10 + int(c-'0')
				if isPartNumber(x, y) {
					isPart = true
				}
			} else {
				if isPart {
					res += val
				}
				isPart = false
				val = 0
			}
		}
	}

	fmt.Println(res)
}

func isPartNumber(x int, y int) bool {
	edges := [][]int{
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

	for _, edge := range edges {
		_x := x + edge[0]
		_y := y + edge[1]
		if _x >= 0 && _x < size && _y >= 0 && _y < size && (schema[_y][_x] < '0' || schema[_y][_x] > '9') && schema[_y][_x] != '.' {
			return true
		}
	}

	return false
}
