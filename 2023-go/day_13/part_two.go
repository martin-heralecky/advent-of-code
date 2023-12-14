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
		grid2 := transpose(grid)

		val := 0

		origTransposed := false
		orig := compute(grid, 0)
		if orig == 0 {
			orig = compute(grid2, 0)
			origTransposed = true
		}

		for r := 0; r < len(grid); r++ {
			for c := 0; c < len(grid[r]); c++ {
				if grid[r][c] == '.' {
					grid[r][c] = '#'
					o := orig
					if origTransposed {
						o = 0
					}
					if i := compute(grid, o); i != 0 {
						val = 100 * i
						r = len(grid)
						break
					}
					grid[r][c] = '.'
				} else {
					grid[r][c] = '.'
					o := orig
					if origTransposed {
						o = 0
					}
					if i := compute(grid, o); i != 0 {
						val = 100 * i
						r = len(grid)
						break
					}
					grid[r][c] = '#'
				}
			}
		}

		if val == 0 {
			for r := 0; r < len(grid2); r++ {
				for c := 0; c < len(grid2[r]); c++ {
					if grid2[r][c] == '.' {
						grid2[r][c] = '#'
						o := orig
						if !origTransposed {
							o = 0
						}
						if i := compute(grid2, o); i != 0 {
							val += i
							r = len(grid2)
							break
						}
						grid2[r][c] = '.'
					} else {
						grid2[r][c] = '.'
						o := orig
						if !origTransposed {
							o = 0
						}
						if i := compute(grid2, o); i != 0 {
							val += i
							r = len(grid2)
							break
						}
						grid2[r][c] = '#'
					}
				}
			}
		}

		res += val
	}

	fmt.Println(res)
}

func compute(grid [][]byte, except int) int {
	for i := 0; i < len(grid)-1; i++ {
		if i+1 == except {
			continue
		}

		yes := true
		for j := 0; i-j >= 0 && i+1+j < len(grid); j++ {
			if !bytes.Equal(grid[i-j], grid[i+1+j]) {
				yes = false
				break
			}
		}

		if yes {
			return i + 1
		}
	}

	return 0
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
