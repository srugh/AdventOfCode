require "set"

def parse_input(path)
  lines = File.readlines(path, chomp: true)
  entries = []

  lines.each do |line|
    left, right = line.split(" | ")
    patterns = left.split(" ")
    outputs  = right.split(" ")
    entries << [patterns, outputs]
  end

  entries
end

def pattern_to_set(pattern)
  # "cdfbe" -> Set["c","d","f","b","e"]
  Set.new(pattern.chars)
end

def decode_entry(pattern_strings, output_strings)
  # Convert all ten unique patterns to sets
  pattern_sets = pattern_strings.map { |s| pattern_to_set(s) }

  # This will hold: Set[...] => digit
  pattern_to_digit = {}

  # Also keep digit => Set[...] for the important ones
  digit_to_pattern = {}

  # ---- Step 1: find 1, 4, 7, 8 by length ----
  pattern_sets.each do |p|
    case p.size
    when 2
      pattern_to_digit[p] = 1
      digit_to_pattern[1] = p
    when 3
      pattern_to_digit[p] = 7
      digit_to_pattern[7] = p
    when 4
      pattern_to_digit[p] = 4
      digit_to_pattern[4] = p
    when 7
      pattern_to_digit[p] = 8
      digit_to_pattern[8] = p
    end
  end

  # ---- Step 2: classify length-6 patterns as 0, 6, or 9 ----
  length_6_patterns = pattern_sets.select { |p| p.size == 6 }

  length_6_patterns.each do |p|
    # 9 contains all segments of 4
    if digit_to_pattern[4].subset?(p)
      pattern_to_digit[p] = 9
      digit_to_pattern[9] = p
    end
  end

  # Remaining length-6 (not already 9) are 0 and 6
  remaining_6 = length_6_patterns.reject { |p| pattern_to_digit.key?(p) }

  remaining_6.each do |p|
    # 0 contains all segments of 1
    if digit_to_pattern[1].subset?(p)
      pattern_to_digit[p] = 0
      digit_to_pattern[0] = p
    else
      # The last one must be 6
      pattern_to_digit[p] = 6
      digit_to_pattern[6] = p
    end
  end

  # ---- Step 3: classify length-5 patterns as 2, 3, or 5 ----
  length_5_patterns = pattern_sets.select { |p| p.size == 5 }

  length_5_patterns.each do |p|
    # 3 contains all segments of 1
    if digit_to_pattern[1].subset?(p)
      pattern_to_digit[p] = 3
      digit_to_pattern[3] = p
    end
  end

  remaining_5 = length_5_patterns.reject { |p| pattern_to_digit.key?(p) }

  remaining_5.each do |p|
    # 5 is subset of 6
    if p.subset?(digit_to_pattern[6])
      pattern_to_digit[p] = 5
      digit_to_pattern[5] = p
    else
      # The last one must be 2
      pattern_to_digit[p] = 2
      digit_to_pattern[2] = p
    end
  end

  # ---- Step 4: decode the 4 output digits ----
  digits = []

  output_strings.each do |out|
    out_set = pattern_to_set(out)
    digit   = pattern_to_digit[out_set]
    digits << digit
  end

  # Turn [d1, d2, d3, d4] into an integer
  value = digits[0] * 1000 + digits[1] * 100 + digits[2] * 10 + digits[3]
  value
end

def part1(entries)
  # Count only digits 1,4,7,8 in the outputs
  easy_lengths = [2, 3, 4, 7]
  count = 0

  entries.each do |(_patterns, outputs)|
    outputs.each do |out|
      count += 1 if easy_lengths.include?(out.length)
    end
  end

  count
end

def part2(entries)
  total = 0

  entries.each do |patterns, outputs|
    total += decode_entry(patterns, outputs)
  end

  total
end

# -----------------------------
# Usage
# -----------------------------

path    = "Inputs/day-08.txt"
entries = parse_input(path)

puts "part 1: #{part1(entries)}"
puts "part 2: #{part2(entries)}"
