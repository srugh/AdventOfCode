# frozen_string_literal: true

def read_data(input_file)
  File.read(input_file).lines.map { |line| line.strip.split('x').map(&:to_i) }
end

def calc_ribbon(gift_dimensions)
  wrap_ribbon = gift_dimensions.min(2).map { |side| side * 2 }.sum
  bow_ribbon = gift_dimensions.reduce(:*)
  [wrap_ribbon, bow_ribbon]
end

def calculate_total_ribbon_needed(all_gift_dimensions)
  all_gift_dimensions.reduce(0) do |total_ribbon, gift_dimensions|
    wrapping_ribbon, bow_ribbon = calc_ribbon(gift_dimensions)
    total_ribbon + wrapping_ribbon + bow_ribbon
  end
end

input_file = 'Inputs/day-02.txt'

all_gift_dimensions = read_data(input_file)
puts "Total ribbon needed: #{calculate_total_ribbon_needed(all_gift_dimensions)}"
