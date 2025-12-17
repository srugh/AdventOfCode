# frozen_string_literal: true

def parse_input(path)
  File.readlines(path, chomp: true)
end

def solve_part1(banks)
  total = 0

  banks.each do |bank|
    joltage_offsets = Hash.new { |hash, key| hash[key] = [] }

    bank.each_char.with_index do |ch, i|
      joltage_offsets[ch.to_i].push(i)
    end

    9.downto(1) do |joltage|
      next unless joltage_offsets.key?(joltage)
      next if joltage_offsets[joltage].first == bank.length - 1

      second_digit = bank[(joltage_offsets[joltage].first + 1)..].chars.map(&:to_i).max
      total += (joltage * 10) + second_digit
      break
    end
  end
  total
end

def solve_part2(banks)
  batteries_needed = 12
  banks.sum do |bank|
    max_joltage(bank, batteries_needed).to_i
  end
end

def max_joltage(bank, batteries_needed)
  result = ''
  current_offset = 0

  while result.length < batteries_needed
    last_possible_start_offset = bank.length - (batteries_needed - result.length)

    best_digit = -1
    best_pos   = -1

    current_offset.upto(last_possible_start_offset).each do |i|
      joltage = bank[i].to_i

      next unless joltage > best_digit

      best_digit = joltage
      best_pos   = i
      break if best_digit == 9
    end

    result << best_digit.to_s
    current_offset = best_pos + 1
  end

  result
end

path = 'Inputs/day-03.txt'
banks = parse_input(path)

puts "part 1: #{solve_part1(banks)}"
puts "part 2: #{solve_part2(banks)}"
