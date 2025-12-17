# frozen_string_literal: true

def parse_input(path)
  File.read(path).chars.map(&:to_i)
end

def solve_part1(_input)
  [0, 1, 0, -1]
end

path = 'Inputs/day-16.txt'
input = parse_input(path)
puts solve_part1(input)
