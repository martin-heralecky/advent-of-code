package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	regex, _ := regexp.Compile("\\d")

	res := 0
	for scanner.Scan() {
		digits := regex.FindAllString(scanner.Text(), -1)
		n, _ := strconv.Atoi(digits[0] + digits[len(digits)-1])
		res += n
	}

	fmt.Println(res)
}
