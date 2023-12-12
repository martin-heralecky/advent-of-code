package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	arrangements := 0

	for scanner.Scan() {
		l := scanner.Text()
		record := []byte(l[:strings.Index(l, " ")])
		lengths := make([]int, 0)
		for _, n := range strings.Split(l[strings.Index(l, " ")+1:], ",") {
			i, _ := strconv.Atoi(n)
			lengths = append(lengths, i)
		}

		positions := make([]int, 0)
		start := 0

		for {
			i := -1
			if start < len(record) {
				i = nextPos(record[start:], lengths[len(positions)])
			}

			if i != -1 {
				if len(positions) == len(lengths)-1 {
					recordCopy := make([]byte, len(record))
					copy(recordCopy, record)
					for pi, p := range positions {
						for o := 0; o < lengths[pi]; o++ {
							recordCopy[p+o] = '_'
						}
					}
					for o := 0; o < lengths[len(positions)]; o++ {
						recordCopy[start+i+o] = '_'
					}

					if !bytes.Contains(recordCopy, []byte{'#'}) {
						arrangements++
					}

					start += i + 1
				} else {
					positions = append(positions, start+i)
					start += i + lengths[len(positions)-1] + 1
				}
			} else if len(positions) > 0 {
				start = positions[len(positions)-1] + 1
				positions = positions[:len(positions)-1]
			} else {
				break
			}
		}
	}

	fmt.Println(arrangements)
}

func nextPos(record []byte, size int) int {
	length := 0

	for i, c := range record {
		if c == '#' || c == '?' {
			length++
		} else {
			length = 0
		}

		if length == size {
			if i == len(record)-1 || record[i+1] != '#' {
				return i - length + 1
			} else {
				length--
			}
		}
	}

	return -1
}
