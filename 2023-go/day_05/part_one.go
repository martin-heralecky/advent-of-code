package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	seeds := make([]int, 0)

	scanner.Scan()
	for _, s := range strings.Split(scanner.Text()[7:], " ") {
		sn, _ := strconv.Atoi(s)
		seeds = append(seeds, sn)
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

		maps = append(maps, m)
	}

	minLoc := math.MaxInt
	for _, s := range seeds {
		for _, m := range maps {
			for _, r := range m {
				if s >= r[1] && s <= r[1]+r[2] {
					s = r[0] + (s - r[1])
					break
				}
			}
		}

		if s < minLoc {
			minLoc = s
		}
	}

	fmt.Println(minLoc)
}
