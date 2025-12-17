# frozen_string_literal: true

require 'csv'

text = ''
enabled_mult_matches = []
mult_match_positions = []
do_match_positions = []
dont_match_positions = []

mult_regex = Regexp.new('mul\\(\\d{1,3},\\d{1,3}\\)')
do_regex = Regexp.new('do\\(\\)')
dont_regex = Regexp.new("don't\\(\\)")

File.foreach('../Inputs/input2.txt') do |line|
  # matches.push(line.scan(regex))
  text += line
end

all_array = []

mult_matches = text.scan(mult_regex) do |match|
  mult_match_positions.push(Regexp.last_match.begin(0))

  all_array[Regexp.last_match.begin(0)] = match
end

text.scan(do_regex) do
  do_match_positions.push(Regexp.last_match.begin(0))

  all_array[Regexp.last_match.begin(0)] = 'enable'
end

text.scan(dont_regex) do
  dont_match_positions.push(Regexp.last_match.begin(0))

  all_array[Regexp.last_match.begin(0)] = 'disable'
end

# puts mult_matches.size
# puts mult_match_positions.size
# puts do_match_positions.size
# puts dont_match_positions.size

mult_enabled = true

(0..(all_array.size - 1)).each do |i|
  next if all_array[i].nil?

  value = all_array[i]
  puts value
  if value != 'enable' && value != 'disable' && mult_enabled
    enabled_mult_matches.push(mult_matches[all_array[i]])
  elsif value == 'enable'
    mult_enabled = true
  elsif value == 'disable'
    mult_enabled = false
  end
end

puts enabled_mult_matches.size

total = 0
regexp2 = Regexp.new('\\d{1,3}')

enabled_mult_matches.each do |match|
  numbers = match.scan(regexp2)
  total += numbers[0].to_i * numbers[1].to_i
end

puts total
