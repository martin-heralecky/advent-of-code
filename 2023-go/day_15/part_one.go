package main

import (
	"bytes"
	"fmt"
	"os"
)

func main() {
	file, _ := os.ReadFile("input.txt")

	seq := bytes.Split(bytes.TrimSpace(file), []byte{','})

	res := 0
	for _, step := range seq {
		hash := 0
		for _, c := range step {
			hash += int(c)
			hash *= 17
			hash %= 256
		}
		res += hash
	}

	fmt.Println(res)
}
