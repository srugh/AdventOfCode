package main

import (
	"bufio"
	"log"
	"os"
	"sort"
	"strconv"
	"strings"
)

func validPassphrasePart1(words []string) bool {
	freqMap := make(map[string]int)

	// Count the frequency of each string
	for _, str := range words {
		freqMap[str]++

		// if there's more than 1 the passphrase is invalid
		if freqMap[str] > 1 {
			return false
		}
	}

	return true
}

func sortString(str string) string {

	// Convert the string to a slice of runes
	runes := []rune(str)

	// Sort the runes
	sort.Slice(runes, func(i, j int) bool {
		return runes[i] < runes[j]
	})

	// Convert the sorted runes back to a string
	return string(runes)

}

func validPassphrasePart2(words []string) bool {
	var sortedWords []string

	// convert each word to the sorted version of itself and reuse part 1 from there, rather than check literally each permutation
	for _, str := range words {
		sortedWords = append(sortedWords, sortString(str))
	}

	return validPassphrasePart1(sortedWords)
}

func main() {
	path := "day-04/day-04.txt"
	validCountPart1 := 0
	validCountPart2 := 0
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
		words := strings.Fields(scanner.Text())

		if validPassphrasePart1(words) {
			validCountPart1 += 1
		}
		if validPassphrasePart2(words) {
			validCountPart2 += 1
		}
	}

	println("validCountPart1:" + strconv.Itoa(validCountPart1))
	println("validCountPart2:" + strconv.Itoa(validCountPart2))

}
