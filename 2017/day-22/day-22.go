package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func main() {
	path := "day-22/day-22.txt"
	//solutionPart1 := 0
	// solutionPart2 := 0

	var grid [][]byte

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
		line := scanner.Text()
		grid = append(grid, []byte(line))
	}
	for _, row := range grid {
		fmt.Println(string(row))
	}
}
