# frozen_string_literal: true

def parse_input(path)
  File.read(path).split("\n\n")
      .map { |chunk| chunk.split("\n").map(&:to_i) }
end

def solve_part1(input)
  totals = input.map(&:sum)
  totals.max
end

def solve_part2(input)
  totals = input.map(&:sum)
  totals = totals.uniq.sort.reverse!

  (totals[0] + totals[1] + totals[2])
end

path = 'Inputs/day-01.txt'
input = parse_input(path)
part_1 = solve_part1(input)
part_2 = solve_part2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"
