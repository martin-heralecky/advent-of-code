package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
)

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	scanner.Scan()
	directions := make([]int, 0)
	for _, d := range scanner.Bytes() {
		directions = append(directions, map[byte]int{'L': 0, 'R': 1}[d])
	}
	scanner.Scan()

	rules := make([]string, 0)
	for scanner.Scan() {
		rules = append(rules, scanner.Text())
	}

	sort.Slice(rules, func(i, j int) bool {
		return rules[i][2] < rules[j][2]
	})

	nodeMap := make(map[string]uint16)
	for i, r := range rules {
		nodeMap[r[:3]] = uint16(i)
	}

	net := make([][2]uint16, len(rules))
	for _, r := range rules {
		net[nodeMap[r[:3]]] = [2]uint16{nodeMap[r[7:10]], nodeMap[r[12:15]]}
	}

	cur := make([]uint16, 0)
	for s, i := range nodeMap {
		if s[2] == 'A' {
			cur = append(cur, i)
		}
	}
	c0, c1, c2, c3, c4, c5 := cur[0], cur[1], cur[2], cur[3], cur[4], cur[5]

	firstZI := uint16(9999)
	for s, i := range nodeMap {
		if s[2] == 'Z' && i < firstZI {
			firstZI = i
		}
	}

	steps := 0
	for {
		dir := directions[steps%len(directions)]
		c0 = net[c0][dir]
		c1 = net[c1][dir]
		c2 = net[c2][dir]
		c3 = net[c3][dir]
		c4 = net[c4][dir]
		c5 = net[c5][dir]

		steps++

		if c0 >= firstZI && c1 >= firstZI && c2 >= firstZI && c3 >= firstZI && c4 >= firstZI && c5 >= firstZI {
			break
		}
	}

	fmt.Println(steps)
}
