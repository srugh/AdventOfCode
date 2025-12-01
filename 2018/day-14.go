package main

import (
	"fmt"
	"strconv"
)

// calcRecipes mirrors the Ruby 'calc_recipes' function
func calcRecipes(before int, rec1 int, rec2 int) int {
	// Convert 'before' to a slice of integers
	beforeStr := strconv.Itoa(before)
	target := make([]int, len(beforeStr))
	for i, c := range beforeStr {
		target[i] = int(c - '0')
	}
	targetLength := len(target)

	// Initialize recipes with the first two recipes
	recipes := []int{rec1, rec2}

	// Initialize elf positions
	elf1 := 0
	elf2 := 1

	for {
		// Debugging: Print progress every 10,000 recipes
		if len(recipes)%10000 == 0 {
			fmt.Println(len(recipes))
		}

		// Calculate the sum of the current recipes
		sum := recipes[elf1] + recipes[elf2]

		// Add new recipes based on the sum
		if sum >= 10 {
			recipes = append(recipes, 1)
			// Check if the target appears after adding '1'
			if len(recipes) >= targetLength {
				match := true
				for i := 0; i < targetLength; i++ {
					if recipes[len(recipes)-targetLength+i] != target[i] {
						match = false
						break
					}
				}
				if match {
					fmt.Println("WINNER")
					return len(recipes) - targetLength
				}
			}
		}
		recipes = append(recipes, sum%10)
		// Check if the target appears after adding the last digit
		if len(recipes) >= targetLength {
			match := true
			for i := 0; i < targetLength; i++ {
				if recipes[len(recipes)-targetLength+i] != target[i] {
					match = false
					break
				}
			}
			if match {
				fmt.Println("WINNER")
				return len(recipes) - targetLength
			}
		}

		// Update elf positions
		elf1 = (elf1 + recipes[elf1] + 1) % len(recipes)
		elf2 = (elf2 + recipes[elf2] + 1) % len(recipes)
	}
}

func main() {
	// Define your input values
	// Uncomment the desired input
	//input2 := 51589  // Expected Output: 9
	//input2 := 1245   // Previously 01245, converted to 1245; Expected Output: 5
	//input2 := 92510  // Expected Output: 18
	//input2 := 59414  // Expected Output: 2018
	input2 := 894501 // Adjust as needed

	// Initial recipes
	rec1 := 3
	rec2 := 7

	// Display the target
	fmt.Printf("Target Sequence: %d\n", input2)

	// Calculate the position
	part2 := calcRecipes(input2, rec1, rec2)

	// Display the result
	fmt.Printf("Answer: %d\n", part2)
}
