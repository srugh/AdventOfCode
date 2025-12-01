package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

type Instruction struct {
	UpdateRegister        string
	Operation             string
	OperationValue        int
	ConditionalRegister   string
	ConditionalExpression string
	ConditionalValue      int
}

func conditional(instruction Instruction, registers map[string]int) bool {
	valid := false
	switch instruction.ConditionalExpression {
	case "==":
		if registers[instruction.ConditionalRegister] == instruction.ConditionalValue {
			return true
		}
	case "!=":
		if registers[instruction.ConditionalRegister] != instruction.ConditionalValue {
			return true
		}
	case ">=":
		if registers[instruction.ConditionalRegister] >= instruction.ConditionalValue {
			return true
		}
	case ">":
		if registers[instruction.ConditionalRegister] > instruction.ConditionalValue {
			return true
		}
	case "<=":
		if registers[instruction.ConditionalRegister] <= instruction.ConditionalValue {
			return true
		}
	case "<":
		if registers[instruction.ConditionalRegister] < instruction.ConditionalValue {
			return true
		}
	default:
		fmt.Println("unhandled:", instruction.ConditionalExpression)
	}
	return valid
}

func executeInstruction(instruction Instruction, registers map[string]int, maxRegisterValue *int) {
	if instruction.Operation == "inc" {
		registers[instruction.UpdateRegister] = registers[instruction.UpdateRegister] + instruction.OperationValue
	}
	if instruction.Operation == "dec" {
		registers[instruction.UpdateRegister] = registers[instruction.UpdateRegister] - instruction.OperationValue
	}
	if registers[instruction.UpdateRegister] > *maxRegisterValue {
		*maxRegisterValue = registers[instruction.UpdateRegister]
	}
}

func main() {
	path := "day-08/day-08.txt"
	solutionPart1 := 0
	solutionPart2 := 0
	registers := make(map[string]int)

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
		opValue, err := strconv.Atoi(fields[2])
		if err != nil {
			log.Fatal(err)
		}

		conValue, err := strconv.Atoi(fields[6])
		if err != nil {
			log.Fatal(err)
		}

		instruction := Instruction{
			UpdateRegister:        fields[0],
			Operation:             fields[1],
			OperationValue:        opValue,
			ConditionalRegister:   fields[4],
			ConditionalExpression: fields[5],
			ConditionalValue:      conValue,
		}
		if _, ok := registers[instruction.UpdateRegister]; !ok {
			registers[instruction.UpdateRegister] = 0
		}
		if _, ok := registers[instruction.ConditionalRegister]; !ok {
			registers[instruction.ConditionalRegister] = 0
		}
		if conditional(instruction, registers) {
			executeInstruction(instruction, registers, &solutionPart2)
		}

	}

	for _, value := range registers {
		if value > solutionPart1 {
			solutionPart1 = value
		}
	}

	fmt.Println("solution part 1: ", solutionPart1)
	fmt.Println("solution part 2: ", solutionPart2)

}
