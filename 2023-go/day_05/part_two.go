package main

import (
	"bufio"
	"fmt"
	"log"
	"math"
	"os"
	"sort"
	"strconv"
	"strings"
)

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	seeds := make([][2]int, 0)

	scanner.Scan()
	seedsStr := strings.Split(scanner.Text()[7:], " ")
	for i := 0; i < len(seedsStr); i += 2 {
		start, _ := strconv.Atoi(seedsStr[i])
		length, _ := strconv.Atoi(seedsStr[i+1])
		seeds = append(seeds, [2]int{start, length})
	}

	scanner.Scan()

	maps := make([][][3]int, 0)

	for scanner.Scan() {
		m := make([][3]int, 0)
		for scanner.Scan() && scanner.Text() != "" {
			nums := strings.Split(scanner.Text(), " ")

			destStart, _ := strconv.Atoi(nums[0])
			srcStart, _ := strconv.Atoi(nums[1])
			length, _ := strconv.Atoi(nums[2])

			m = append(m, [3]int{destStart, srcStart, length})
		}

		sort.Slice(m, func(i, j int) bool {
			return m[i][1] < m[j][1]
		})

		maps = append(maps, m)
	}

	for _, m := range maps {
		// May contain duplicates.
		newSeeds := make([][2]int, 0)

		for _, s := range seeds {
			done := false
			for _, r := range m {
				// r is sorted by source start.

				if s[0]+s[1] <= r[1] {
					// Map is fully after seed.
					break
				} else if s[0] < r[1] && s[0]+s[1] > r[1] {
					// Map starts after seed and intersects it.
					newSeeds = append(newSeeds, [2]int{s[0], r[1] - s[0]}) // No mapping.
					if s[0]+s[1] < r[1]+r[2] {
						// Seed ends before/at map end.
						newSeeds = append(newSeeds, [2]int{r[0], s[0] + s[1] - r[1]})
						done = true
						break
					} else {
						newSeeds = append(newSeeds, [2]int{r[0], r[2]})
						s = [2]int{r[1] + r[2], s[0] + s[1] - (r[1] + r[2])}
					}
				} else if s[0] >= r[1] && s[0] <= r[1]+r[2]-1 {
					// Map starts before seed and intersects it.
					if s[0]+s[1] <= r[1]+r[2] {
						newSeeds = append(newSeeds, [2]int{r[0] + (s[0] - r[1]), s[1]})
						done = true
						break
					} else {
						newSeeds = append(newSeeds, [2]int{r[0] + (s[0] - r[1]), r[1] + r[2] - s[0]})
						s = [2]int{r[1] + r[2], s[1] - (r[1] + r[2] - s[0])}
					}
				} else if s[0] >= r[1]+r[2] {
					// Map is fully before seed.
				} else {
					log.Fatal("No match: ", s, r)
				}
			}

			if !done {
				newSeeds = append(newSeeds, s) // No mapping.
			}
		}

		seeds = newSeeds
	}

	minLoc := math.MaxInt
	for _, s := range seeds {
		if s[0] < minLoc {
			minLoc = s[0]
		}
	}

	fmt.Println(minLoc)
}
