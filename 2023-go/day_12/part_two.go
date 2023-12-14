package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type cacheKey struct {
	record  string
	lengths int
}

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	arrangements := 0

	for scanner.Scan() {
		l := scanner.Text()
		record := []byte(l[:strings.Index(l, " ")])
		record = append(append(append(append(append(append(append(append(record, '?'), record...), '?'), record...), '?'), record...), '?'), record...)
		lengths := make([]int, 0)
		for _, n := range strings.Split(l[strings.Index(l, " ")+1:], ",") {
			i, _ := strconv.Atoi(n)
			lengths = append(lengths, i)
		}
		lengths = append(append(append(append(lengths, lengths...), lengths...), lengths...), lengths...)

		cache := make(map[cacheKey]int)
		arrangements += compute(record, lengths, cache)
	}

	fmt.Println(arrangements)
}

func compute(record []byte, lengths []int, cache map[cacheKey]int) int {
	ck := cacheKey{string(record), len(lengths)}
	if cached, ok := cache[ck]; ok {
		return cached
	}

	res := 0
	for _, p := range findAllPositions(record, lengths[0]) {
		if len(lengths) > 1 && len(record) > p+lengths[0]+1 {
			res += compute(record[p+lengths[0]+1:], lengths[1:], cache)
		} else if len(lengths) == 1 && (len(record) <= p+lengths[0] || bytes.IndexByte(record[p+lengths[0]:], '#') == -1) {
			res++
		}
	}

	cache[ck] = res

	return res
}

func findAllPositions(record []byte, length int) []int {
	res := make([]int, 0)

	for start := 0; start < len(record)-length+1; start++ {
		if bytes.IndexByte(record[start:start+length], '.') == -1 && (start+length == len(record) || record[start+length] != '#') {
			res = append(res, start)
		}

		if record[start] == '#' {
			break
		}
	}

	return res
}
