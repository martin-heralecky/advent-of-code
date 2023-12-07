package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
)

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	cardMap := map[uint8]int{
		'2': 0,
		'3': 1,
		'4': 2,
		'5': 3,
		'6': 4,
		'7': 5,
		'8': 6,
		'9': 7,
		'T': 8,
		'J': -1,
		'Q': 10,
		'K': 11,
		'A': 12,
	}

	type hand struct {
		cards [5]int
		bid   int
	}

	hands := make([]hand, 0)

	for scanner.Scan() {
		cards := scanner.Text()[:5]
		bid, _ := strconv.Atoi(scanner.Text()[6:])
		hands = append(hands, hand{[5]int{cardMap[cards[0]], cardMap[cards[1]], cardMap[cards[2]], cardMap[cards[3]], cardMap[cards[4]]}, bid})
	}

	sort.Slice(hands, func(i, j int) bool {
		iType := getType(hands[i].cards)
		jType := getType(hands[j].cards)

		if iType == jType {
			iVal := 0
			jVal := 0
			for x := 0; x < 5; x++ {
				iVal = iVal*100 + hands[i].cards[x]
				jVal = jVal*100 + hands[j].cards[x]
			}
			return iVal < jVal
		}

		return iType < jType
	})

	res := 0
	for i, h := range hands {
		res += (i + 1) * h.bid
	}

	fmt.Println(res)
}

func getType(cards [5]int) int {
	cm := make(map[int]int)
	for _, c := range cards {
		cm[c]++
	}

	if cm[-1] > 0 {
		maxCard := 0
		maxCardI := 0
		for i, c := range cm {
			if c > maxCard && i >= 0 {
				maxCard = c
				maxCardI = i
			}
		}
		cm[maxCardI] += cm[-1]
		delete(cm, -1)
	}

	cd := make(map[int]int)
	for _, b := range cm {
		cd[b]++
	}

	if cd[5] > 0 {
		return 5 // five of a kind
	} else if cd[4] > 0 {
		return 4 // four of a kind
	} else if cd[3] > 0 {
		if cd[2] > 0 {
			return 3 // full house
		} else {
			return 2 // three of a kind
		}
	} else if cd[2] > 1 {
		return 1 // two pair
	} else if cd[2] > 0 {
		return 0 // one pair
	} else {
		return -1 // high card
	}
}
