package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

func main() {
	path := "day-02/day-02.txt"
	var data [][]int
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
		fields := strings.Fields(scanner.Text())
		var nums []int

		for _, field := range fields {
			num, err := strconv.Atoi(field)
			if err != nil {
				// Handle the error, e.g., log it or skip the value
				fmt.Println("Error converting:", err)
				continue
			}
			nums = append(nums, num)
		}
		data = append(data, nums)
	}

	checkSum_1 := 0
	checkSum_2 := 0
	println(len(data))
	println(len(data[0]))
	for i := 0; i < len(data); i++ {

		smallest := 9999999999
		largest := -1
		for j := 0; j < len(data[i]); j++ {

			if data[i][j] < smallest {
				smallest = data[i][j]
			}
			if data[i][j] > largest {
				largest = data[i][j]
			}

			for k := 0; k < len(data[i]); k++ {
				if data[i][j]%data[i][k] == 0 && j != k {
					checkSum_2 += data[i][j] / data[i][k]
				}
			}
		}
		checkSum_1 += largest - smallest
	}

	println("checkSum_1:" + strconv.Itoa(checkSum_1))
	println("checkSum_2:" + strconv.Itoa(checkSum_2))

}
