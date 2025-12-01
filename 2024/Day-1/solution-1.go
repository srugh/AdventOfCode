package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

func populateArrays(fileName string, leftArray *[]int, rightArray *[]int) {
	// Open the file
	file, err := os.Open(fileName)

	if err != nil {
		fmt.Printf("Error opening file: %v\n", err)
		return
	}
	defer file.Close()

	// Create a scanner to read the file line by line
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()

		values := strings.Fields(line)
		leftVal, err := strconv.Atoi(values[0])

		if err != nil {
			panic(err)
		}

		rightVal, err := strconv.Atoi(values[1])

		if err != nil {
			panic(err)
		}

		*leftArray = append(*leftArray, leftVal)
		*rightArray = append(*rightArray, rightVal)

	}

	// Check for errors during scanning
	if err := scanner.Err(); err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		return
	}

}

func absInt(n int) int {
	if n < 0 {
		return -n
	}
	return n
}

func calculateDistance(leftArray []int, rightArray []int) int {
	totDistance := 0

	for i := 0; i < len(leftArray); i++ {
		distance := absInt(leftArray[i] - rightArray[i])
		totDistance += distance
	}

	return totDistance

}

func main() {
	// sample_file := "../Inputs/sample.txt"
	real_file := "Inputs/input-1.txt"

	left_array := []int{}
	right_array := []int{}

	total_distance := 0

	populateArrays(real_file, &left_array, &right_array)

	sort.Ints(left_array)
	sort.Ints(right_array)

	total_distance = calculateDistance(left_array, right_array)

	fmt.Println(total_distance)
}
