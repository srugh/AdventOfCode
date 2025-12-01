package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

func runInstructionsPart1(instructions []int) int {
	lowerBound := 0
	upperBound := len(instructions) - 1

	index := 0
	count := 0

	for index >= lowerBound && index <= upperBound {
		count++
		curIndex := index
		index += instructions[index]
		instructions[curIndex] += 1
	}

	return count
}

func runInstructionsPart2(instructions []int) int {
	lowerBound := 0
	upperBound := len(instructions) - 1

	index := 0
	count := 0

	for index >= lowerBound && index <= upperBound {
		count++
		curIndex := index
		index += instructions[index]
		if instructions[curIndex] >= 3 {
			instructions[curIndex] -= 1

		} else {
			instructions[curIndex] += 1
		}
	}

	return count
}

func main() {

	path := "day-05/day-05.txt"
	solutionPart1 := 0
	solutionPart2 := 0
	var instructions []int

	// Open the file
	file, err := os.Open(path)

	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	// Create a new scanner to read the file line by line
	scanner := bufio.NewScanner(file)

	// Loop through the file and read each line
	for scanner.Scan() {
		numStr := strings.Fields(scanner.Text())
		num, err := strconv.Atoi(numStr[0])
		if err != nil {
			log.Fatal(err)
		}
		instructions = append(instructions, num)
	}
	copyInstructions := make([]int, len(instructions))
	copy(copyInstructions, instructions)

	solutionPart1 = runInstructionsPart1(instructions)
	solutionPart2 = runInstructionsPart2(copyInstructions)

	fmt.Println("Part 1 solution: ", solutionPart1)
	fmt.Println("Part 2 solution: ", solutionPart2)
}
