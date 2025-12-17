# frozen_string_literal: true

def parse_input(path)
  grid = []
  File.foreach(path) do |line|
    grid.push(line.chomp.chars.map(&:to_i))
  end

  grid
end

def solve_part1(input)
  dirs = [[1, 0], [-1, 0], [0, -1], [0, 1]]
  lows = Set.new
  input.each_with_index do |rows, r|
    rows.each_with_index do |col, c|
      adjs = []
      dirs.each do |dir|
        loc = [dir[0] + r, dir[1] + c]
        next if loc[0].negative? || loc[0] > input.size - 1 || loc[1].negative? || loc[1] > input[0].size - 1

        adjs.push(input[loc[0]][loc[1]])
      end
      lows.add([r, c]) if adjs.min > col
    end
  end
  score = 0
  lows.each do |low|
    p low
    score += input[low[0]][low[1]] + 1
  end
  score
end

def solve_part2(input); end

path = 'Inputs/day-09.txt'
input = parse_input(path)
part_1 = solve_part1(input)
part_2 = solve_part2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"
