package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	d := []string{"1", "2", "3", "4", "5", "6", "7", "8", "9", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}

	res := 0
	for scanner.Scan() {
		var left string
		var right string
		leftIndex := 999
		rightIndex := -1
		for i, s := range d {
			index := strings.Index(scanner.Text(), s)
			if index != -1 && index < leftIndex {
				leftIndex = index
				left = d[i%9]
			}

			index = strings.LastIndex(scanner.Text(), s)
			if index != -1 && index > rightIndex {
				rightIndex = index
				right = d[i%9]
			}
		}

		n, _ := strconv.Atoi(left + right)
		res += n
	}

	fmt.Println(res)
}
