# frozen_string_literal: true

def parse_input(input)
  total = 0
  digit_words = {
    'zero' => 0, 'one' => 1, 'two' => 2, 'three' => 3,
    'four' => 4, 'five' => 5, 'six' => 6, 'seven' => 7,
    'eight' => 8, 'nine' => 9
  }
  digit_regex = Regexp.union(digit_words.keys)
  File.foreach(input) do |line|
    mod_line = line.chomp.dup

    mod_line = mod_line.gsub(digit_regex) { |match| digit_words[match] }

    digits = mod_line.scan(/\d/)
    puts "Processed line: #{mod_line}, Digits: #{digits.inspect}" # Debug output

    next if digits.empty?

    total += (digits.first + digits.last).to_i
    puts "First: #{digits.first}, Last: #{digits.last}, Combined: #{(digits.first + digits.last).to_i}" # Debug output
  end
  puts total
end

input = 'Inputs/day-01.txt'
parse_input(input)
