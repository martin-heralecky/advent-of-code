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

	lineRegex, _ := regexp.Compile("^Game \\d+: (.*)$")
	cubeRegex, _ := regexp.Compile("(\\d+) ([a-z]+)")

	res := 0
	for scanner.Scan() {
		matches := lineRegex.FindStringSubmatch(scanner.Text())

		maxRed := 0
		maxGreen := 0
		maxBlue := 0

		for _, set := range strings.Split(matches[1], "; ") {
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

			if red > maxRed {
				maxRed = red
			}

			if green > maxGreen {
				maxGreen = green
			}

			if blue > maxBlue {
				maxBlue = blue
			}
		}

		res += maxRed * maxGreen * maxBlue
	}

	fmt.Println(res)
}
