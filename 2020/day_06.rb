# frozen_string_literal: true

def parse_input(file)
  File.read(file)
      .split(/\n{2,}/)
      .map(&:split)
end

def solve_part1(answers)
  counts = []
  answers.each do |answer|
    group_string = ''
    answer.each do |foo|
      group_string << foo
    end

    counts.push(group_string.chars.uniq.size)
  end

  counts.inject(:+)
end

def solve_part2(answers)
  counts = []

  answers.each do |answer|
    group_hash = {}
    answer.each do |foo|
      chars = foo.chars
      chars.each do |c|
        group_hash[c] = 0 unless group_hash.key?(c)
        group_hash[c] += 1
      end
    end
    count = 0
    group_hash.each_value do |value|
      count += 1 if value == answer.size
    end
    counts.push(count)
  end

  counts.inject(:+)
end

file = 'Inputs/day-06.txt'

answers = parse_input(file)

part_1 = solve_part1(answers)
part_2 = solve_part2(answers)

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"
