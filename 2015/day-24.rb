# frozen_string_literal: true

def parse_input(path)
  File.read(path).split("\n").map(&:to_i)
end

def solve_part1(input)
  Hash.new { |hash, key| hash[key] = [] }
  all_combos_for_target = []
  target = input.sum / 3
  8.times do |i|
    puts i
    input.combination(i).each do |combo|
      all_combos_for_target.push(combo) if combo.sum == target
    end
  end

  unique_triplets = []
  # Iterate through all combinations of 3 arrays
  all_combos_for_target.combination(3).each do |triplet|
    # Flatten the triplet of arrays into a single array
    combined_values = triplet.flatten

    # Check if all values in the combined array are unique
    unique_triplets << triplet if combined_values.uniq.size == combined_values.size
  end

  p unique_triplets
end

path = 'Inputs/day-24.txt'
input = parse_input(path)
p_1 = solve_part1(input)
puts "p_1: #{p_1}"
