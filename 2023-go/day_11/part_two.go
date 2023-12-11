package main

import (
	"fmt"
	"os"
)

type pos struct {
	x int
	y int
}

func main() {
	file, _ := os.Open("input.txt")

	grid := make([][]byte, 140)
	for i := 0; i < 140; i++ {
		grid[i] = make([]byte, 140)
		_, _ = file.Read(grid[i])
		_, _ = file.Seek(1, 1)
	}

	galaxies := make([]pos, 0)

	for y, row := range grid {
		for x, c := range row {
			if c == '#' {
				galaxies = append(galaxies, pos{x, y})
			}
		}
	}

	expandRows := make([]int, 0)
	expandCols := make([]int, 0)

	for y := 0; y < len(grid); y++ {
		expand := true
		for x := 0; x < len(grid[y]); x++ {
			if grid[y][x] == '#' {
				expand = false
				break
			}
		}

		if expand {
			expandRows = append(expandRows, y+len(expandRows)*999999)
		}
	}

	for x := 0; x < len(grid[0]); x++ {
		expand := true
		for y := 0; y < len(grid); y++ {
			if grid[y][x] == '#' {
				expand = false
				break
			}
		}

		if expand {
			expandCols = append(expandCols, x+len(expandCols)*999999)
		}
	}

	for _, y := range expandRows {
		for i, g := range galaxies {
			if g.y > y {
				galaxies[i].y += 999999
			}
		}
	}

	for _, x := range expandCols {
		for i, g := range galaxies {
			if g.x > x {
				galaxies[i].x += 999999
			}
		}
	}

	res := 0

	for i, g1 := range galaxies {
		for _, g2 := range galaxies[i+1:] {
			if g1.x < g2.x {
				res += g2.x - g1.x
			} else {
				res += g1.x - g2.x
			}
			if g1.y < g2.y {
				res += g2.y - g1.y
			} else {
				res += g1.y - g2.y
			}
		}
	}

	fmt.Println(res)
}
