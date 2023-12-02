package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	lineRegex, _ := regexp.Compile("^Game (\\d+): (.*)$")
	cubeRegex, _ := regexp.Compile("(\\d+) ([a-z]+)")

	res := 0
	for scanner.Scan() {
		matches := lineRegex.FindStringSubmatch(scanner.Text())
		id, _ := strconv.Atoi(matches[1])

		possible := true
		for _, set := range strings.Split(matches[2], "; ") {
			red := 0
			green := 0
			blue := 0

			for _, cube := range cubeRegex.FindAllStringSubmatch(set, -1) {
				val, _ := strconv.Atoi(cube[1])
				if cube[2] == "red" {
					red += val
				} else if cube[2] == "green" {
					green += val
				} else if cube[2] == "blue" {
					blue += val
				}
			}

			if red > 12 || green > 13 || blue > 14 {
				possible = false
				break
			}
		}

		if possible {
			res += id
		}
	}

	fmt.Println(res)
}
