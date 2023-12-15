package main

import (
	"bytes"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

type lens struct {
	label  string
	length int
}

func main() {
	file, _ := os.ReadFile("input.txt")
	stepRegex, _ := regexp.Compile("^([a-z]+)([=\\-])(\\d*)$")

	seq := bytes.Split(bytes.TrimSpace(file), []byte{','})

	boxes := make([][]lens, 256)
	for i := 0; i < len(boxes); i++ {
		boxes[i] = make([]lens, 0)
	}

	for _, step := range seq {
		matches := stepRegex.FindSubmatch(step)

		label := string(matches[1])
		op := matches[2][0]

		labelHash := 0
		for _, c := range label {
			labelHash += int(c)
			labelHash *= 17
			labelHash %= 256
		}

		box := labelHash

		if op == '=' {
			length, _ := strconv.Atoi(string(matches[3]))

			alreadyPresent := false
			for i, l := range boxes[box] {
				if l.label == label {
					boxes[box][i].length = length
					alreadyPresent = true
					break
				}
			}

			if !alreadyPresent {
				boxes[box] = append(boxes[box], lens{label, length})
			}
		} else {
			for i, l := range boxes[box] {
				if l.label == label {
					boxes[box] = append(boxes[box][:i], boxes[box][i+1:]...)
					break
				}
			}
		}
	}

	res := 0
	for i, b := range boxes {
		for j, l := range b {
			res += (1 + i) * (j + 1) * l.length
		}
	}

	fmt.Println(res)
}
