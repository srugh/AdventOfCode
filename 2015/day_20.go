package main

import (
	"fmt"
	"math"
)

func calculateGiftsWithLimit(house, multiplier, limit int) int {
	gifts := 0
	for i := 1; i <= int(math.Sqrt(float64(house))); i++ {
		if house%i == 0 {
			if house/i <= limit {
				gifts += i * multiplier
			}
			if i <= limit && i != house/i {
				gifts += (house / i) * multiplier
			}
		}
	}
	return gifts
}

func main() {
	const targetGifts = 29000000
	const multiplier = 11
	const elfLimit = 50
	count := 1

	for {
		gifts := calculateGiftsWithLimit(count, multiplier, elfLimit)
		if gifts >= targetGifts {
			fmt.Printf("Found house: %d with gifts: %d\n", count, gifts)
			break
		}
		count++
	}
}
