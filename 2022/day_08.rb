# frozen_string_literal: true

def parse_input(path)
  grid = []
  File.foreach(path) do |line|
    grid.push(line.chomp.chars.map(&:to_i))
  end

  grid
end

def solve_part1(grid)
  grid.each_with_index do |row, r|
    next if r.zero? || r == grid.size - 1

    row.each_with_index do |_col, c|
      next if c.zero? || c == grid[0].size
    end
  end
end

def solve_part2(input); end

path = 'Inputs/day-08.txt'
input = parse_input(path)
part_1 = solve_part1(input)
part_2 = solve_part2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"
