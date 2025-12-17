# frozen_string_literal: true

def parse_input(path)
  File.read(path).split(',').map(&:to_i)
end

def solve_part1(input)
  80.times do |_i|
    spawns = 0
    input.each_with_index do |fish, idx|
      if fish.zero?
        spawns += 1
        input[idx] = 6
      else
        input[idx] -= 1
      end
    end
    spawns.times do
      input.push(8)
    end
  end
  input.count
end

def solve_part2(input)
  counts = Array.new(9, 0)
  input.each do |t|
    counts[t] += 1
  end

  256.times do
    new_fish = counts[0]

    # shift timers down
    (0..7).each do |t|
      counts[t] = counts[t + 1]
    end

    counts[6] += new_fish   # old 0s reset to 6
    counts[8]  = new_fish   # new fish at 8
  end

  counts.sum
end

path = 'Inputs/day-06.txt'
input = parse_input(path)
# input = [3,4,3,1,2]
part_1 = solve_part1(input.clone)
part_2 = solve_part2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"
