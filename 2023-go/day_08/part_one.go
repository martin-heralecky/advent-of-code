package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
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

	net := make(map[string][2]string)
	regex, _ := regexp.Compile("^(...) = \\((...), (...)\\)$")
	for scanner.Scan() {
		matches := regex.FindStringSubmatch(scanner.Text())
		net[matches[1]] = [2]string{matches[2], matches[3]}
	}

	i := 0
	for cur := "AAA"; cur != "ZZZ"; cur, i = net[cur][directions[i%len(directions)]], i+1 {
	}
	fmt.Println(i)
}
