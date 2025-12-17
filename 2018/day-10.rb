# frozen_string_literal: true

def parse_input(input)
  points = []
  File.readlines(input, chomp: true).each do |line|
    # Use a regex to capture all integers (including multi-digit and negative numbers)
    matches = line.scan(/-?\d+/)
    # Extract in the order: x, y, x_velocity, y_velocity
    x, y, x_vel, y_vel = matches.map(&:to_i)
    # Map x (left-right) to col and y (up-down) to row
    points.push([y, x, y_vel, x_vel])
  end

  points
end

def find_image(points, max_seconds = 100)
  seconds = 0
  # grid = build_grid(points)

  while seconds < max_seconds
    grid = build_grid(points, seconds)
    puts "Seconds: #{seconds}"
    pretty_print_grid(grid)
    seconds += 1
  end

  seconds
end

def build_grid(points, seconds, size = 150)
  grid = Array.new(size) { Array.new(size, '.') }
  puts "Seconds: #{seconds}"
  points.each_with_index do |point, _idx|
    r, c, r_v, c_v = point
    row = ((seconds * r_v) + r) % size
    col = ((seconds * c_v) + c) % size

    # puts "Start \t row: #{r} \t col: #{c} \t row_v: #{r_v} \t col_v: #{c_v}"
    # puts "After \t row: #{row} \t col: #{col}"
    grid[row][col] = '#'
  end

  grid
end

def pretty_print_grid(grid)
  grid.each_with_index do |row, _r_idx|
    row.each_with_index do |col, _c_idx|
      print col
    end
    print "\n"
  end
  print "\n"
end
input = 'Inputs/day-10.txt'

points = parse_input(input)
p points
seconds = find_image(points, 60)

puts "seconds: #{seconds}"
