# frozen_string_literal: true

def read_data(input_file)
  File.read(input_file).lines.map(&:strip)
end

def has_three_vowels?(string)
  vowels = string.scan(/[aeiou]/i)
  vowels.size >= 3
end

def has_double_letter?(string)
  string.match(/(.)\1/)
end

def has_no_forbidden_substrings?(string)
  !string.match(/ab|cd|pq|xy/)
end

def passes_all_checks?(string)
  has_three_vowels?(string) && has_double_letter?(string) && has_no_forbidden_substrings?(string)
end

def calculate_nice_strings(strings)
  strings.select { |string| passes_all_checks?(string) }.size
end

input_file = 'Inputs/day-05.txt'

strings = read_data(input_file)
puts "Total nice strings: #{calculate_nice_strings(strings)}"
