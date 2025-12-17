# frozen_string_literal: true

def parse_input(path)
  File.read(path).split("\n").map(&:split)
end

def solve_part1(input)
  dirs = {}
  dirs['U'] = [-1, 0]
  dirs['D'] = [1, 0]
  dirs['R'] = [0, 1]
  dirs['L'] = [0, -1]

  visited = Set.new

  start = [0, 0]
  head = start
  tail = start
  visited.add(tail)

  input.each_with_index do |move, _idx|
    d = move[0]
    steps = move[1].to_i

    steps.times do
      head = [head[0] + dirs[d][0], head[1] + dirs[d][1]]

      next unless tailsmove?(head, tail, dirs)

      dx = head[0] - tail[0]
      dy = head[1] - tail[1]
      tail = [tail[0] + (dx <=> 0), tail[1] + (dy <=> 0)]
      visited.add(tail)
    end
  end
  visited.size
end

def tailsmove?(head, tail, _dirs)
  (head[0] - tail[0]).abs > 1 || (head[1] - tail[1]).abs > 1
end

def solve_part2(input); end

path = 'Inputs/day-09.txt'
# path = "Inputs/day-09-sample.txt"
input = parse_input(path)
part_1 = solve_part1(input)
part_2 = solve_part2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"
