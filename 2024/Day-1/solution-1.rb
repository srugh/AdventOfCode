# frozen_string_literal: true

require 'csv'

## Read inputs for Arrays, "Left" and "Right"
def populateArrays(input_file, left_array, right_array)
  File.foreach(input_file) do |line|
    values = line.split(/\s+/)
    left_array << values[0].to_i
    right_array << values[1].to_i
  end
end

def calculateDistance(sorted_left_array, sorted_right_array)
  total_distance = 0

  sorted_left_array.size.times do |i|
    distance = sorted_left_array[i] - sorted_right_array[i]
    total_distance += distance.abs
  end

  total_distance
end

## Initalize and run

# sample_file = "Inputs/sample.txt"
real_file = 'Inputs/input-1.txt'

unsorted_left_array = []
unsorted_right_array = []

# initalize arrays from input file
populateArrays(real_file, unsorted_left_array, unsorted_right_array)

# sort each array
sorted_left_array = unsorted_left_array.sort
sorted_right_array = unsorted_right_array.sort

# calculate total distance
total_distance = calculateDistance(sorted_left_array, sorted_right_array)

# print total distance
puts total_distance
