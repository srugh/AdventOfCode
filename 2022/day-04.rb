# frozen_string_literal: true

def parse_input(path)
  File.read(path).split("\n").map { |c| c.scan(/(\d+)-(\d+)/) }
end

def solve_part1(input)
  total = 0
  input.each do |pair|
    cleaned = []
    pair.each_with_index do |assignment, _idx|
      cleaned.push(assignment[0].to_i..assignment[1].to_i)
    end
    if (cleaned[0].cover?(cleaned[1].first) && cleaned[0].cover?(cleaned[1].last)) ||
       (cleaned[1].cover?(cleaned[0].first) && cleaned[1].cover?(cleaned[0].last))
      total += 1
    end
  end
  total
end

def solve_part2(input)
  total = 0
  input.each do |pair|
    cleaned = []
    pair.each_with_index do |assignment, _idx|
      cleaned.push(assignment[0].to_i..assignment[1].to_i)
    end
    if cleaned[0].overlap?(cleaned[1]) ||
       cleaned[1].overlap?(cleaned[0])
      total += 1
    end
  end
  total
end

path = 'Inputs/day-04.txt'
input = parse_input(path)
part_1 = solve_part1(input)
part_2 = solve_part2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"
