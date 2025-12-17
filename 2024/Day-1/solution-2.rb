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

def calculateSimilarityScore(left_array, right_array)
  similarity_score = 0
  occurrences_hash = {}

  # populate hash for right array where key is the value in the array and value is the count of occurences in the array
  right_array.each do |value|
    if occurrences_hash.key?(value)
      occurrences_hash[value] += 1
    else
      occurrences_hash[value] = 1
    end
  end

  # calculate the similarity score by multiplying each number in left array by the count of that value in the right array using the hash
  left_array.each do |value|
    similarity_score += value * occurrences_hash[value] if occurrences_hash.key?(value)
  end

  similarity_score
end

## Initalize and run
real_file = '../Inputs/input-1.txt'

left_array = []
right_array = []

# initalize arrays from input file
populateArrays(real_file, left_array, right_array)

# calculate similarity score
similarity_score = calculateSimilarityScore(left_array, right_array)

# print similarity score
puts similarity_score
