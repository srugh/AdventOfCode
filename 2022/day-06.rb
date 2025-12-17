# frozen_string_literal: true

def parse_input(path)
  File.readlines(path, chomp: true)
end

def solve_part1(input)
  str = ''
  offset = 0
  while str.length != str.chars.uniq.length || str.length < 4
    str = input[offset, 4]
    offset += 1
    puts "offset: #{offset}, str: #{str}"
  end
  offset + 3
end

def solve_part2(input)
  str = ''
  offset = 0
  while str.length != str.chars.uniq.length || str.length < 4
    str = input[offset, 14]
    offset += 1
    puts "offset: #{offset}, str: #{str}"
  end
  offset + 13
end

path = 'Inputs/day-06.txt'
input = parse_input(path)
part_1 = solve_part1(input[0])
part_2 = solve_part2(input[0])

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"
