# frozen_string_literal: true

require 'csv'

def read_data(input_file)
  input_sections = File.read(input_file).split("\n\n")

  rules = input_sections[0].lines.map { |line| line.strip.split('|').map(&:to_i) }
  updates = input_sections[1].lines.map { |line| line.strip.split(',').map(&:to_i) }

  [rules, updates]
end

def valid_update?(rules, update)
  rules.all? do |before, after|
    before_pos = update.index(before)
    after_pos = update.index(after)

    before_pos.nil? || after_pos.nil? || before_pos < after_pos
  end
end

def filter_valid_updates(rules, updates)
  updates.select { |update| valid_update?(rules, update) }
end

def middle_element(update)
  update[update.size / 2]
end

def calculate_total(rules, updates)
  filter_valid_updates(rules, updates).map { |valid| middle_element(valid) }.sum
end

## Run Script

# file = "Inputs/sample.txt"
file = 'Inputs/input1.txt'

# initalize arrays from input file
rules, updates = read_data(file)

# print the total result
puts "Total: #{calculate_total(rules, updates)}"
