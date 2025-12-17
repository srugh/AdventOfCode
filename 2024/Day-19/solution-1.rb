# frozen_string_literal: true

def parse_input(input_file)
  parts = File.read(input_file).split("\n\n")

  options = parts[0].split(', ')

  desires = parts[1].split("\n").map(&:chomp)

  [options, desires]
end

def check_matches(options, desire)
  temp = []
  options.each do |option|
    contains = desire.match(option)
    temp.push(option) if contains
  end

  puts "matches: #{temp.size} \t of #{options.size}"

  build_permutations(options, temp)
end

def build_permutations(_options, perms)
  max_size_of_perms = 3
  perm_strings = []

  max_size_of_perms.times.each do |idx|
    puts "Building perm: #{idx}"
    n_perms = perms.repeated_permutation(idx + 1).to_a
    str = ''
    n_perms.each do |perm|
      str = ''
      perm.each do |towel|
        str += towel
      end
      perm_strings.push(str)
    end
  end
  puts perm_strings.size
  # p perms
  perm_strings
end

def can_construct_design(available_patterns, design)
  # Dynamic programming table to check constructability
  dp = Array.new(design.length + 1, false)
  dp[0] = true # Base case: empty design can always be constructed

  (1..design.length).each do |i|
    available_patterns.each do |pattern|
      len = pattern.length
      # Check if the pattern matches the end of the current substring
      dp[i] ||= dp[i - len] if i >= len && design[i - len, len] == pattern
    end
  end

  dp[design.length] # Return whether the full design can be constructed
end

def calc_possibilities(options, desires)
  possible_count = 0
  results = []

  desires.each do |desire|
    if can_construct_design(options, desire)
      possible_count += 1
      results << "#{desire}: possible"
    else
      results << "#{desire}: impossible"
    end
  end

  [possible_count, results]
end
input_file = 'Inputs/input.txt'

options, desires = parse_input(input_file)
count, = calc_possibilities(options, desires)

puts "Total possibilities: #{count} of #{desires.size}"
