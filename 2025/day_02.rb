# frozen_string_literal: true

def parse_input(path)
  File.read(path).split(',').map { |range| range.split('-').map(&:to_i) }
end

def solve_part1(ranges)
  invalid_sum = 0

  ranges.each do |low, high|
    low.upto(high) do |id|
      id_str = id.to_s
      next if id_str.size.odd?

      midpoint = id_str.length / 2
      next unless id_str[0, midpoint] == id_str[midpoint, midpoint]

      invalid_sum += id
    end
  end
  invalid_sum
end

def solve_part2(ranges)
  invalid_sum = 0

  ranges.each do |low, high|
    low.upto(high) do |id|
      id_str = id.to_s
      id_len = id_str.length

      (1..(id_len / 2)).each do |chunk_len|
        next unless (id_len % chunk_len).zero?

        potential = id_str[0, chunk_len] * (id_len / chunk_len)

        if potential == id_str
          invalid_sum += id
          break
        end
      end
    end
  end
  invalid_sum
end

path = 'Inputs/day-02.txt'
ranges = parse_input(path)

puts "part 1: #{solve_part1(ranges)}"
puts "part 2: #{solve_part2(ranges)}"
