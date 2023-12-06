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

	var games [4]struct {
		time int
		dist int
	}
	for i := 0; i < 4; i++ {
		games[i].time, _ = strconv.Atoi(n[i])
		games[i].dist, _ = strconv.Atoi(n[i+4])
	}

	res := 1
	for _, g := range games {
		n := 0
		for t := 0; t <= g.time; t++ {
			if t*(g.time-t) > g.dist {
				n++
			}
		}
		res *= n
	}

	fmt.Println(res)
}
