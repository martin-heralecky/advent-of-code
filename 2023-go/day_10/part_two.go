package main

import (
	"fmt"
	"os"
)

const (
	dirUp = iota
	dirRight
	dirDown
	dirLeft
)

const size = 140

var pipe map[[2]int]bool

func main() {
	file, _ := os.Open("input.txt")

	grid := make([][]byte, size)
	for i := 0; i < size; i++ {
		grid[i] = make([]byte, size)
		_, _ = file.Read(grid[i])
		_, _ = file.Seek(1, 1)
	}

	sx, sy := 0, 0
	cx, cy := 0, 0
	px, py := 0, 0

	for y, row := range grid {
		for x, c := range row {
			if c == 'S' {
				sx, sy = x, y
				break
			}
		}
	}

	connectUp := grid[sy-1][sx] == '|' || grid[sy-1][sx] == 'F' || grid[sy-1][sx] == '7'
	connectDown := grid[sy+1][sx] == '|' || grid[sy+1][sx] == 'L' || grid[sy+1][sx] == 'J'
	connectLeft := grid[sy][sx-1] == '-' || grid[sy][sx-1] == 'F' || grid[sy][sx-1] == 'L'
	connectRight := grid[sy][sx+1] == '-' || grid[sy][sx+1] == '7' || grid[sy][sx+1] == 'J'
	if connectUp && connectRight {
		grid[sy][sx] = 'L'
	} else if connectUp && connectDown {
		grid[sy][sx] = '|'
	} else if connectUp && connectLeft {
		grid[sy][sx] = 'J'
	} else if connectRight && connectDown {
		grid[sy][sx] = 'F'
	} else if connectRight && connectLeft {
		grid[sy][sx] = '-'
	} else if connectDown && connectLeft {
		grid[sy][sx] = '7'
	}

	if grid[sy-1][sx] == '|' || grid[sy-1][sx] == 'F' || grid[sy-1][sx] == '7' {
		cx, cy = sx, sy-1
	} else if grid[sy][sx+1] == '-' || grid[sy][sx+1] == 'J' || grid[sy][sx+1] == '7' {
		cx, cy = sx+1, sy
	} else {
		cx, cy = sx, sy+1
	}
	px, py = sx, sy

	m := map[byte][4]int{
		'-': {-1, 0, 1, 0},
		'|': {0, -1, 0, 1},
		'J': {-1, 0, 0, -1},
		'7': {-1, 0, 0, 1},
		'L': {1, 0, 0, -1},
		'F': {1, 0, 0, 1},
	}

	pipe = make(map[[2]int]bool)
	pipeOrdered := make([][2]int, 0)
	pipe[[2]int{cx, cy}] = true
	pipeOrdered = append(pipeOrdered, [2]int{cx, cy})

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

		pipe[[2]int{cx, cy}] = true
		pipeOrdered = append(pipeOrdered, [2]int{cx, cy})
	}

	left := make(map[[2]int]bool)
	right := make(map[[2]int]bool)
	dir := 0
	if grid[pipeOrdered[0][1]][pipeOrdered[0][0]] == '|' {
		if pipeOrdered[1][1] < pipeOrdered[0][1] {
			dir = dirUp
		} else {
			dir = dirDown
		}
	} else if grid[pipeOrdered[0][1]][pipeOrdered[0][0]] == 'F' {
		if pipeOrdered[1][0] > pipeOrdered[0][0] {
			dir = dirUp
		} else {
			dir = dirLeft
		}
	} else if grid[pipeOrdered[0][1]][pipeOrdered[0][0]] == '7' {
		if pipeOrdered[1][0] < pipeOrdered[0][0] {
			dir = dirUp
		} else {
			dir = dirRight
		}
	} else if grid[pipeOrdered[0][1]][pipeOrdered[0][0]] == '-' {
		if pipeOrdered[1][0] < pipeOrdered[0][0] {
			dir = dirLeft
		} else {
			dir = dirRight
		}
	} else if grid[pipeOrdered[0][1]][pipeOrdered[0][0]] == 'L' {
		if pipeOrdered[1][0] > pipeOrdered[0][0] {
			dir = dirDown
		} else {
			dir = dirLeft
		}
	} else if grid[pipeOrdered[0][1]][pipeOrdered[0][0]] == 'J' {
		if pipeOrdered[1][0] < pipeOrdered[0][0] {
			dir = dirDown
		} else {
			dir = dirRight
		}
	}

	for _, coord := range pipeOrdered {
		c := grid[coord[1]][coord[0]]
		if c == '|' {
			if dir == dirUp {
				scanHor(coord[0], coord[1], left, right)
			} else {
				scanHor(coord[0], coord[1], right, left)
			}
		} else if c == 'F' {
			if dir == dirUp {
				scanHor(coord[0], coord[1], left, right)
				scanVer(coord[0], coord[1], right, left)
				dir = dirRight
			} else {
				scanVer(coord[0], coord[1], left, right)
				scanHor(coord[0], coord[1], right, left)
				dir = dirDown
			}
		} else if c == '7' {
			if dir == dirUp {
				scanHor(coord[0], coord[1], left, right)
				scanVer(coord[0], coord[1], left, right)
				dir = dirLeft
			} else {
				scanVer(coord[0], coord[1], right, left)
				scanHor(coord[0], coord[1], right, left)
				dir = dirDown
			}
		} else if c == '-' {
			if dir == dirRight {
				scanVer(coord[0], coord[1], right, left)
			} else {
				scanVer(coord[0], coord[1], left, right)
			}
		} else if c == 'L' {
			if dir == dirDown {
				scanHor(coord[0], coord[1], right, left)
				scanVer(coord[0], coord[1], right, left)
				dir = dirRight
			} else {
				scanVer(coord[0], coord[1], left, right)
				scanHor(coord[0], coord[1], left, right)
				dir = dirUp
			}
		} else if c == 'J' {
			if dir == dirDown {
				scanHor(coord[0], coord[1], right, left)
				scanVer(coord[0], coord[1], left, right)
				dir = dirLeft
			} else {
				scanVer(coord[0], coord[1], right, left)
				scanHor(coord[0], coord[1], left, right)
				dir = dirUp
			}
		}
	}

	for y := 0; y < size; y++ {
		for x := 0; x < size; x++ {
			if left[[2]int{x, y}] {
				fmt.Print("<")
			} else if right[[2]int{x, y}] {
				fmt.Print(">")
			} else {
				fmt.Print(".")
			}
		}
		fmt.Println()
	}

	fmt.Println(len(left), len(right))
}

func scanHor(_x int, y int, left map[[2]int]bool, right map[[2]int]bool) {
	for x := _x - 1; x >= 0; x-- {
		if pipe[([2]int{x, y})] {
			break
		}
		left[[2]int{x, y}] = true
	}
	for x := _x + 1; x < size; x++ {
		if pipe[([2]int{x, y})] {
			break
		}
		right[[2]int{x, y}] = true
	}
}

func scanVer(x int, _y int, down map[[2]int]bool, up map[[2]int]bool) {
	for y := _y - 1; y >= 0; y-- {
		if pipe[([2]int{x, y})] {
			break
		}
		up[[2]int{x, y}] = true
	}
	for y := _y + 1; y < size; y++ {
		if pipe[([2]int{x, y})] {
			break
		}
		down[[2]int{x, y}] = true
	}
}
