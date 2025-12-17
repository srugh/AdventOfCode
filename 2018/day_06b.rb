# frozen_string_literal: true

# Define a Coordinate class to store X and Y positions
class Coordinate
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

# Method to parse a single line of input into a Coordinate object
def parse_coordinate(line)
  raise "Invalid coordinate format: #{line}" unless line =~ /^(\d+),\s*(\d+)$/

  x = Regexp.last_match(1).to_i
  y = Regexp.last_match(2).to_i
  Coordinate.new(x, y)
end

# Read and parse all coordinates from the input file
def read_coordinates(file_path)
  coordinates = []
  File.foreach(file_path) do |line|
    coordinates << parse_coordinate(line.strip)
  end
  coordinates
end

# Determine the grid boundaries based on coordinates
def determine_boundaries(coordinates, buffer = 100)
  min_x = coordinates.map(&:x).min - buffer
  max_x = coordinates.map(&:x).max + buffer
  min_y = coordinates.map(&:y).min - buffer
  max_y = coordinates.map(&:y).max + buffer
  { min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y }
end

# Calculate Manhattan distance between two points
def manhattan_distance(x1, y1, x2, y2)
  (x1 - x2).abs + (y1 - y2).abs
end

# Assign each grid point to check if it's within the valid region
def calculate_valid_region_size(coordinates, boundaries, distance_threshold)
  valid_region_size = 0

  (boundaries[:min_x]..boundaries[:max_x]).each do |x|
    (boundaries[:min_y]..boundaries[:max_y]).each do |y|
      total_distance = coordinates.reduce(0) do |sum, coord|
        sum + manhattan_distance(x, y, coord.x, coord.y)
      end

      valid_region_size += 1 if total_distance < distance_threshold
    end
    # Optional: Progress indicator for large grids
    print '.' if (x % 100).zero?
  end

  valid_region_size
end

# Main Execution Flow
def main
  input_file = 'Inputs/day-06.txt' # Replace with your input file path
  coordinates = read_coordinates(input_file)
  puts "Parsed #{coordinates.size} coordinates."

  buffer = 100 # Adjust buffer size based on input specifics
  boundaries = determine_boundaries(coordinates, buffer)
  puts 'Grid boundaries:'
  puts "X: #{boundaries[:min_x]} to #{boundaries[:max_x]}"
  puts "Y: #{boundaries[:min_y]} to #{boundaries[:max_y]}"

  distance_threshold = 10_000
  puts "Calculating valid region size with distance threshold < #{distance_threshold}..."
  valid_region_size = calculate_valid_region_size(coordinates, boundaries, distance_threshold)
  puts "\nThe size of the valid region is: #{valid_region_size}"
end

# Run the script
main
