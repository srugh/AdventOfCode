# frozen_string_literal: true

MASK = 0xFFFF

def solve_part1(a, b)
  a_mult = 16_807
  b_mult = 48_271
  div = 2_147_483_647
  count = 0
  40_000_000.times do |_i|
    a = a * a_mult % div
    b = b * b_mult % div
    count += 1 if (a & MASK) == (b & MASK)
  end
  count
end

def solve_part2(a, b)
  a_mult = 16_807
  b_mult = 48_271
  div = 2_147_483_647
  count = 0
  5_000_000.times do |_i|
    loop do
      a = (a * a_mult) % div
      break if (a % 4).zero?
    end

    loop do
      b = (b * b_mult) % div
      break if (b % 8).zero?
    end

    count += 1 if (a & MASK) == (b & MASK)
  end
  count
end

a = 679
b = 771

puts "part 1: #{solve_part1(a, b)}"
puts "part 2: #{solve_part2(a, b)}"
