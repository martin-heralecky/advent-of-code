package main

import (
	"bytes"
	"fmt"
	"os"
)

func main() {
	file, _ := os.ReadFile("input.txt")

	res := 0
	for _, chunk := range bytes.Split(bytes.TrimSpace(file), []byte{'\n', '\n'}) {
		grid := bytes.Split(chunk, []byte{'\n'})
		res += 100 * compute(grid)
		res += compute(transpose(grid))
	}

	fmt.Println(res)
}

func compute(grid [][]byte) int {
	res := 0

	for i := 0; i < len(grid)-1; i++ {
		yes := true
		for j := 0; i-j >= 0 && i+1+j < len(grid); j++ {
			if !bytes.Equal(grid[i-j], grid[i+1+j]) {
				yes = false
				break
			}
		}

		if yes {
			res += i + 1
		}
	}

	return res
}

func transpose(src [][]byte) [][]byte {
	res := make([][]byte, len(src[0]))
	for i := range res {
		res[i] = make([]byte, len(src))
	}
	for r := 0; r < len(src[0]); r++ {
		for c := 0; c < len(src); c++ {
			res[r][c] = src[c][r]
		}
	}
	return res
}
