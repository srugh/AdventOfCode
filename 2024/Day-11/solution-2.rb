require 'set'

# Cache to store the results of count(stone, steps)
$cache = {}

# Recursive function to calculate the number of stones for a given stone and remaining blinks
def count(stone, steps)
  # Base case: If no more steps, this stone contributes 1
  return 1 if steps == 0

  # Check cache to avoid recalculating
  cache_key = [stone, steps]
  #return $cache[cache_key] if $cache.key?(cache_key)

  # Process stone based on the rules
  result = if stone == 0
             count(1, steps - 1)
           elsif stone.digits.size.even?
             digits = stone.to_s
             half = digits.size / 2
             count(digits[0...half].to_i, steps - 1) +
               count(digits[half..].to_i, steps - 1)
           else
             count(stone * 2024, steps - 1)
           end

  # Store result in cache and return
  $cache[cache_key] = result
end

# Process the initial list of stones
def calc_stones(stones, blinks)
  stones.sum { |stone| count(stone, blinks) }
end

# Example Usage
stones = [773, 79858, 0, 71, 213357, 2937, 1, 3998391] # Input stones
blinks = 75 # Number of blinks to calculate

puts "Total stones after #{blinks} blinks: #{calc_stones(stones, blinks)}"
