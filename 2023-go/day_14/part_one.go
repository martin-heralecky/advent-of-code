package main

import (
	"bytes"
	"fmt"
	"os"
)

func main() {
	file, _ := os.ReadFile("input.txt")

	grid := bytes.Split(bytes.TrimSpace(file), []byte{'\n'})

	res := 0
	for ri, row := range grid {
		for ci, c := range row {
			if c == 'O' {
				grid[ri][ci] = '.'
				i := ri
				for i > 0 && grid[i-1][ci] == '.' {
					i--
				}
				grid[i][ci] = 'O'
				res += len(grid) - i
			}
		}
	}

	fmt.Println(res)
}
