package main

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
)

func main() {
	file, _ := os.ReadFile("input.txt")
	regex, _ := regexp.Compile("\\d+")
	n := regex.FindAllString(string(file), -1)

	time, _ := strconv.Atoi(n[0] + n[1] + n[2] + n[3])
	dist, _ := strconv.Atoi(n[4] + n[5] + n[6] + n[7])

	res := 0
	for t := 0; t <= time; t++ {
		if t*(time-t) > dist {
			res++
		}
	}

	fmt.Println(res)
}
