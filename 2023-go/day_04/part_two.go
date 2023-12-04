package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strings"
)

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	regex, _ := regexp.Compile(": (.*) \\| (.*)$")

	total := 0

	counts := make([]int, 200)

	id := 0
	for scanner.Scan() {
		line := scanner.Text()
		matches := regex.FindStringSubmatch(strings.ReplaceAll(line, "  ", " "))

		winning := make(map[string]bool)
		for _, n := range strings.Split(matches[1], " ") {
			winning[n] = true
		}

		i := 1
		for _, n := range strings.Split(matches[2], " ") {
			if winning[n] {
				counts[id+i] += counts[id] + 1
				i++
			}
		}

		total += counts[id] + 1

		id++
	}

	fmt.Println(total)
}
