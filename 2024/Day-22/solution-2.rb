# frozen_string_literal: true

# =========================
# Ruby Solution for Both Parts
# =========================

def parse_inputs(input_file)
  File.readlines(input_file).map do |line|
    line.chomp.to_i
  end
end

# =========================
# Part 1: Sum of 2000th Secret Numbers
# =========================

# Function to simulate the evolution of secret numbers
def simulate_secret_numbers(initial_secret, iterations = 2000)
  secret = initial_secret
  iterations.times do
    # Step 1: Multiply by 64
    step1 = secret * 64

    # Step 2: Mix (XOR with step1)
    secret ^= step1

    # Step 3: Prune
    secret %= 16_777_216

    # Step 4: Divide by 32, round down
    step4 = (secret / 32).floor

    # Step 5: Mix (XOR with step4)
    secret ^= step4

    # Step 6: Prune
    secret %= 16_777_216

    # Step 7: Multiply by 2048
    step7 = secret * 2048

    # Step 8: Mix (XOR with step7)
    secret ^= step7

    # Step 9: Prune
    secret %= 16_777_216
  end
  secret
end

# Function to extract the numeric part of the code
def extract_numeric_part(code)
  match = code.match(/\d+/)
  match ? match[0].to_i : 0
end

# =========================
# Part 2: Optimal Four-Change Sequence
# =========================

# Function to extract the price from a secret number
def extract_price(secret_number)
  secret_number % 10
end

# Function to compute price changes
def compute_price_changes(prices)
  (1...prices.size).map do |i|
    (prices[i] - prices[i - 1])
  end
end

# Function to find the optimal four-change sequence
def find_optimal_sequence(buyers_changes, buyers_prices)
  # Hash to map sequences to the list of selling prices where they first occur
  sequence_to_selling_prices = Hash.new { |hash, key| hash[key] = [] }

  buyers_changes.each_with_index do |changes, idx|
    prices = buyers_prices[idx]
    # Slide a window of four changes
    (0..(changes.size - 4)).each do |i|
      sequence = changes[i, 4].join(',') # Use a string as a key
      # Record only the first occurrence per buyer
      next if sequence_to_selling_prices[sequence].any? { |entry| entry[:buyer_idx] == idx }

      # The price at the point of selling is the price after the fourth change
      selling_price = prices[i + 4]
      sequence_to_selling_prices[sequence] << { buyer_idx: idx, price: selling_price }
    end
  end

  # Now, compute the total sum for each sequence
  sequence_sum_map = {}
  sequence_to_selling_prices.each do |sequence, entries|
    total_sum = entries.map { |entry| entry[:price] }.sum
    sequence_sum_map[sequence] = total_sum
  end

  # Find the sequence with the maximum total sum
  optimal_sequence, max_sum = sequence_sum_map.max_by { |_, v| v }

  { sequence: optimal_sequence, total_sum: max_sum }
end

# =========================
# Main Execution
# =========================

# Example Input: List of initial secret numbers
# Replace this list with your actual input
initial_secrets = parse_inputs('Inputs/input.txt')

# -------------------------
# Part 1: Sum of 2000th Secret Numbers
# -------------------------

def part1_sum_2000th_secret(initial_secrets)
  sum = 0
  initial_secrets.each do |initial|
    secret_2000 = simulate_secret_numbers(initial, 2000)
    sum += secret_2000
    puts "Initial Secret: #{initial} => 2000th Secret: #{secret_2000}"
  end
  sum
end

# -------------------------
# Part 2: Optimal Four-Change Sequence
# -------------------------

def part2_optimal_sequence(initial_secrets)
  buyers_prices = []
  buyers_changes = []

  initial_secrets.each do |initial|
    # Simulate 2000 secret numbers
    secrets = []
    secret = initial
    2000.times do
      # Step 1: Multiply by 64, mix, prune
      step1 = secret * 64
      secret ^= step1
      secret %= 16_777_216

      # Step 2: Divide by 32, floor, mix, prune
      step4 = (secret / 32).floor
      secret ^= step4
      secret %= 16_777_216

      # Step 3: Multiply by 2048, mix, prune
      step7 = secret * 2048
      secret ^= step7
      secret %= 16_777_216

      secrets << secret
    end

    # Extract prices
    prices = secrets.map { |sn| extract_price(sn) }
    buyers_prices << prices

    # Compute price changes
    changes = compute_price_changes(prices)
    buyers_changes << changes
  end

  # Find the optimal sequence
  result = find_optimal_sequence(buyers_changes, buyers_prices)

  if result[:sequence].nil?
    puts 'No valid sequence found.'
    0
  else
    # Convert sequence string back to array of integers
    sequence_array = result[:sequence].split(',').map(&:to_i)
    puts "Optimal Sequence of Four Changes: #{sequence_array.join(',')}"
    puts "Total Bananas Earned: #{result[:total_sum]}"
    result[:total_sum]
  end
end

# -------------------------
# Execute Parts 1 and 2
# -------------------------

# Part 1 Execution
puts '----- Part 1: Sum of 2000th Secret Numbers -----'
sum_part1 = part1_sum_2000th_secret(initial_secrets)
puts "Sum of 2000th Secret Numbers: #{sum_part1}"
puts

# Part 2 Execution
puts '----- Part 2: Optimal Four-Change Sequence -----'
sum_part2 = part2_optimal_sequence(initial_secrets)
puts "Total Bananas Earned: #{sum_part2}"
