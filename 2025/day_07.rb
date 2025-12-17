# frozen_string_literal: true

def parse_input(path)
  File.readlines(path, chomp: true)
end

def solve_part1(rows)
  beams = []
  beams << rows[0].index('S')
  split_count = 0

  rows[1..].each do |row|
    splitters = []
    new_beams = []

    row.chars.each_with_index do |c, idx|
      splitters << idx if c == '^'
    end

    beams.each do |b|
      if splitters.include?(b)
        new_beams << (b - 1)
        new_beams << (b + 1)
        split_count += 1
      else
        new_beams << b
      end
    end

    beams = new_beams.uniq
  end
  split_count
end

def solve_part2(rows)
  start = rows[0].index('S')

  counts = Hash.new(0)
  counts[start] = 1

  rows[1..].each do |row|
    new_counts = Hash.new(0)

    counts.each do |col, num|
      cell = row[col]
      if cell == '^'
        new_counts[col - 1] += num
        new_counts[col + 1] += num
      else
        new_counts[col] += num
      end
    end

    counts = new_counts
  end

  counts.values.sum
end

path = 'Inputs/day-07.txt'
rows = parse_input(path)

puts "part 1: #{solve_part1(rows)}"
puts "part 2: #{solve_part2(rows)}"
