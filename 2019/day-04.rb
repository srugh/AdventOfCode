# frozen_string_literal: true

def solve_part1(input)
  min, max = input

  count = 0
  min.upto(max) do |i|
    # criteria
    dbl = false
    inc = true

    str = i.to_s
    (str.length - 1).times do |j|
      inc = false if str[j].to_i > str[j + 1].to_i

      dbl = true if str[j] == str[j + 1]
    end
    count += 1 if dbl && inc
  end
  count
end

def solve_part2(input)
  min, max = input

  count = 0
  min.upto(max) do |i|
    # criteria
    dbl = false
    dbl_2 = false
    inc = true

    str = i.to_s
    (str.length - 1).times do |j|
      inc = false if str[j].to_i > str[j + 1].to_i

      next unless str[j] == str[j + 1]

      dbl = true
      dbl_2 = true if str.count(str[j]) == 2
    end
    count += 1 if dbl && inc && dbl_2
  end
  count
end
input = [387_638, 919_123]
p_1 = solve_part1(input)
p_2 = solve_part2(input)

puts "p_1: #{p_1}"
puts "p_2: #{p_2}"
