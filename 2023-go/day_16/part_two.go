package main

import (
	"bytes"
	"fmt"
	"os"
)

const (
	dirUp = iota
	dirRight
	dirDown
	dirLeft
)

func main() {
	file, _ := os.ReadFile("input.txt")

	grid := bytes.Split(bytes.TrimSpace(file), []byte{'\n'})

	max := 0

	for i := 0; i < len(grid); i++ {
		var n int

		n = compute(grid, [3]int{-1, i, dirRight})
		if n > max {
			max = n
		}

		n = compute(grid, [3]int{len(grid[0]), i, dirLeft})
		if n > max {
			max = n
		}

		n = compute(grid, [3]int{i, -1, dirDown})
		if n > max {
			max = n
		}

		n = compute(grid, [3]int{i, len(grid), dirUp})
		if n > max {
			max = n
		}
	}

	fmt.Println(max)
}

func compute(grid [][]byte, start [3]int) int {
	// x, y
	energized := make(map[[2]int]bool)

	// x, y, dir
	done := make(map[[3]int]bool)

	//var srcTileDir int

	// x, y, dir
	jobs := [][3]int{
		start,
	}

	for i := 0; i < len(jobs); i++ {
		if done[jobs[i]] {
			continue
		}
		done[jobs[i]] = true

		x := jobs[i][0]
		y := jobs[i][1]

		energized[[2]int{x, y}] = true

		if jobs[i][2] == dirRight {
			for x++; x < len(grid[0]) && (grid[y][x] == '.' || grid[y][x] == '-'); x++ {
				energized[[2]int{x, y}] = true
			}

			if x == len(grid[0]) {
				continue
			}

			if grid[y][x] == '/' || grid[y][x] == '|' {
				jobs = append(jobs, [3]int{x, y, dirUp})
			}
			if grid[y][x] == '\\' || grid[y][x] == '|' {
				jobs = append(jobs, [3]int{x, y, dirDown})
			}
		} else if jobs[i][2] == dirLeft {
			for x--; x >= 0 && (grid[y][x] == '.' || grid[y][x] == '-'); x-- {
				energized[[2]int{x, y}] = true
			}

			if x == -1 {
				continue
			}

			if grid[y][x] == '\\' || grid[y][x] == '|' {
				jobs = append(jobs, [3]int{x, y, dirUp})
			}
			if grid[y][x] == '/' || grid[y][x] == '|' {
				jobs = append(jobs, [3]int{x, y, dirDown})
			}
		} else if jobs[i][2] == dirUp {
			for y--; y >= 0 && (grid[y][x] == '.' || grid[y][x] == '|'); y-- {
				energized[[2]int{x, y}] = true
			}

			if y == -1 {
				continue
			}

			if grid[y][x] == '\\' || grid[y][x] == '-' {
				jobs = append(jobs, [3]int{x, y, dirLeft})
			}
			if grid[y][x] == '/' || grid[y][x] == '-' {
				jobs = append(jobs, [3]int{x, y, dirRight})
			}
		} else if jobs[i][2] == dirDown {
			for y++; y < len(grid) && (grid[y][x] == '.' || grid[y][x] == '|'); y++ {
				energized[[2]int{x, y}] = true
			}

			if y == len(grid) {
				continue
			}

			if grid[y][x] == '/' || grid[y][x] == '-' {
				jobs = append(jobs, [3]int{x, y, dirLeft})
			}
			if grid[y][x] == '\\' || grid[y][x] == '-' {
				jobs = append(jobs, [3]int{x, y, dirRight})
			}
		}
	}

	return len(energized) - 1
}
