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

	for scanner.Scan() {
		line := scanner.Text()
		matches := regex.FindStringSubmatch(strings.ReplaceAll(line, "  ", " "))

		winning := make(map[string]bool)
		for _, n := range strings.Split(matches[1], " ") {
			winning[n] = true
		}

		points := 0
		for _, n := range strings.Split(matches[2], " ") {
			if winning[n] {
				if points == 0 {
					points = 1
				} else {
					points *= 2
				}
			}
		}

		total += points
	}

	fmt.Println(total)
}
