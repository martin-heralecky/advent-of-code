package main

import (
	"bytes"
	"fmt"
	"os"
)

func main() {
	file, _ := os.ReadFile("input.txt")

	grid := bytes.Split(bytes.TrimSpace(file), []byte{'\n'})

	past := make(map[string]int)

	start := 0
	length := 0

	for i := 0; ; i++ {
		north(grid)
		west(grid)
		south(grid)
		east(grid)

		h := string(bytes.Join(grid, []byte{}))
		if j, ok := past[h]; ok {
			start = j
			length = i - j
			break
		} else {
			past[h] = i
		}
	}

	for i := 0; i < ((1000000000-start)%length)-1; i++ {
		north(grid)
		west(grid)
		south(grid)
		east(grid)
	}

	res := 0
	for y := 0; y < len(grid); y++ {
		for x := 0; x < len(grid[y]); x++ {
			if grid[y][x] == 'O' {
				res += len(grid) - y
			}
		}
	}

	fmt.Println(res)
}

func north(grid [][]byte) {
	for y := 1; y < len(grid); y++ {
		for x := 0; x < len(grid[y]); x++ {
			if grid[y][x] == 'O' {
				grid[y][x] = '.'
				i := y
				for i > 0 && grid[i-1][x] == '.' {
					i--
				}
				grid[i][x] = 'O'
			}
		}
	}
}

func west(grid [][]byte) {
	for y := 0; y < len(grid); y++ {
		for x := 1; x < len(grid[y]); x++ {
			if grid[y][x] == 'O' {
				grid[y][x] = '.'
				i := x
				for i > 0 && grid[y][i-1] == '.' {
					i--
				}
				grid[y][i] = 'O'
			}
		}
	}
}

func south(grid [][]byte) {
	for y := len(grid) - 2; y >= 0; y-- {
		for x := 0; x < len(grid[y]); x++ {
			if grid[y][x] == 'O' {
				grid[y][x] = '.'
				i := y
				for i < len(grid)-1 && grid[i+1][x] == '.' {
					i++
				}
				grid[i][x] = 'O'
			}
		}
	}
}

func east(grid [][]byte) {
	for y := 0; y < len(grid); y++ {
		for x := len(grid[y]) - 2; x >= 0; x-- {
			if grid[y][x] == 'O' {
				grid[y][x] = '.'
				i := x
				for i < len(grid[y])-1 && grid[y][i+1] == '.' {
					i++
				}
				grid[y][i] = 'O'
			}
		}
	}
}
