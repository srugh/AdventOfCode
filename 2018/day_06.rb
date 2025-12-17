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
def determine_boundaries(coordinates)
  min_x = coordinates.map(&:x).min
  max_x = coordinates.map(&:x).max
  min_y = coordinates.map(&:y).min
  max_y = coordinates.map(&:y).max
  { min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y }
end

# Calculate Manhattan distance between two points
def manhattan_distance(x1, y1, x2, y2)
  (x1 - x2).abs + (y1 - y2).abs
end

# Assign each grid point to the closest coordinate
def assign_grid_points(coordinates, boundaries)
  grid_assignments = {}

  (boundaries[:min_x]..boundaries[:max_x]).each do |x|
    (boundaries[:min_y]..boundaries[:max_y]).each do |y|
      distances = coordinates.map { |coord| manhattan_distance(x, y, coord.x, coord.y) }
      min_distance = distances.min
      closest = distances.each_with_index.select { |dist, _| dist == min_distance }.map(&:last)

      grid_assignments[[x, y]] = if closest.size == 1
                                   closest.first
                                 else
                                   # Tied; do not assign to any coordinate
                                   nil
                                 end
    end
  end

  grid_assignments
end

# Identify coordinates with infinite areas
def find_infinite_coordinates(_coordinates, boundaries, grid_assignments)
  infinite_coords = Set.new

  # Top and Bottom boundaries
  (boundaries[:min_x]..boundaries[:max_x]).each do |x|
    [boundaries[:min_y], boundaries[:max_y]].each do |y|
      coord_index = grid_assignments[[x, y]]
      infinite_coords << coord_index if coord_index
    end
  end

  # Left and Right boundaries
  (boundaries[:min_y]..boundaries[:max_y]).each do |y|
    [boundaries[:min_x], boundaries[:max_x]].each do |x|
      coord_index = grid_assignments[[x, y]]
      infinite_coords << coord_index if coord_index
    end
  end

  infinite_coords
end

# Calculate finite areas
def calculate_finite_areas(_coordinates, infinite_coords, grid_assignments)
  area_counts = Hash.new(0)

  grid_assignments.each_value do |coord_index|
    next if coord_index.nil?
    next if infinite_coords.include?(coord_index)

    area_counts[coord_index] += 1
  end

  area_counts
end

# Find the largest finite area
def find_largest_finite_area(area_counts)
  area_counts.values.max
end

# Main Execution Flow
def main
  input_file = 'Inputs/day-06.txt' # Replace with your input file path
  coordinates = read_coordinates(input_file)
  puts "Parsed #{coordinates.size} coordinates."

  boundaries = determine_boundaries(coordinates)
  puts 'Grid boundaries:'
  puts "X: #{boundaries[:min_x]} to #{boundaries[:max_x]}"
  puts "Y: #{boundaries[:min_y]} to #{boundaries[:max_y]}"

  grid_assignments = assign_grid_points(coordinates, boundaries)
  puts 'Assigned grid points to coordinates.'

  infinite_coords = find_infinite_coordinates(coordinates, boundaries, grid_assignments)
  puts "Identified #{infinite_coords.size} infinite coordinates."

  finite_areas = calculate_finite_areas(coordinates, infinite_coords, grid_assignments)
  if finite_areas.empty?
    puts 'No finite areas found.'
  else
    largest_area = find_largest_finite_area(finite_areas)
    puts "The size of the largest finite area is: #{largest_area}"
  end
end

# Run the script
main
