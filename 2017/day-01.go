package main

import (
	"bufio"
	"log"
	"os"
	"strconv"
)

func main() {
	path := "inputs/day-01.txt"
	line := ""
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
		line = scanner.Text()
	}

	prevNum := -1
	sum_1 := 0
	sum_2 := 0

	midPointDist := len(line) / 2
	println("mid_point: " + strconv.Itoa(midPointDist))
	for idx, char := range line {
		curNum := int(char - '0')

		if prevNum == curNum {
			sum_1 += curNum
		}

		if curNum == int(line[(idx+midPointDist)%len(line)]-'0') {
			sum_2 += curNum
		}
		prevNum = curNum
	}
	if prevNum == int(line[0]-'0') {
		sum_1 += prevNum
	}

	println(sum_1)
	println(sum_2)
}
