package main

import (
	"fmt"
	"os"
)

func main() {
	file, _ := os.Open("input.txt")

	grid := make([][]byte, 140)
	for i := 0; i < 140; i++ {
		grid[i] = make([]byte, 140)
		_, _ = file.Read(grid[i])
		_, _ = file.Seek(1, 1)
	}

	sx, sy := 0, 0
	cx, cy := 0, 0
	px, py := 0, 0
	length := 0

	for y, row := range grid {
		for x, c := range row {
			if c == 'S' {
				sx, sy = x, y
				break
			}
		}
	}

	if grid[sy-1][sx] == '|' || grid[sy-1][sx] == 'F' || grid[sy-1][sx] == '7' {
		cx, cy = sx, sy-1
	} else if grid[sy][sx+1] == '-' || grid[sy][sx+1] == 'J' || grid[sy][sx+1] == '7' {
		cx, cy = sx+1, sy
	} else {
		cx, cy = sx, sy+1
	}
	px, py = sx, sy
	length = 1

	m := map[byte][4]int{
		'-': {-1, 0, 1, 0},
		'|': {0, -1, 0, 1},
		'J': {-1, 0, 0, -1},
		'7': {-1, 0, 0, 1},
		'L': {1, 0, 0, -1},
		'F': {1, 0, 0, 1},
	}

	for cx != sx || cy != sy {
		c := grid[cy][cx]

		if px-cx == m[c][0] && py-cy == m[c][1] {
			px, py = cx, cy
			cx += m[c][2]
			cy += m[c][3]
		} else {
			px, py = cx, cy
			cx += m[c][0]
			cy += m[c][1]
		}

		length++
	}

	fmt.Println(length / 2)
}
