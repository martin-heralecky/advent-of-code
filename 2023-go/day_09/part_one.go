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

	res := 0
	for scanner.Scan() {
		seqs := make([][]int, 1)

		for _, n := range strings.Split(scanner.Text(), " ") {
			i, _ := strconv.Atoi(n)
			seqs[0] = append(seqs[0], i)
		}

		for {
			seqs = append(seqs, make([]int, 0))
			allZeroes := true
			for i := 0; i < len(seqs[len(seqs)-2])-1; i++ {
				d := seqs[len(seqs)-2][i+1] - seqs[len(seqs)-2][i]
				seqs[len(seqs)-1] = append(seqs[len(seqs)-1], d)
				if d != 0 {
					allZeroes = false
				}
			}

			if allZeroes {
				break
			}
		}

		val := 0
		for i := len(seqs) - 2; i >= 0; i-- {
			val = val + seqs[i][len(seqs[i])-1]
		}

		res += val
	}

	fmt.Println(res)
}
