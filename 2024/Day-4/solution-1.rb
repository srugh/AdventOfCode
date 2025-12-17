# frozen_string_literal: true

def populateWordSearch(input_file)
  grid = []
  File.foreach(input_file) do |line|
    row = (0..(line.length - 1)).map do |i|
      line[i]
    end
    grid.push(row)
  end

  grid
end

def findOccurances(grid, left, top, right, bottom)
  x_coords = []
  m_coords = []
  a_coords = []
  s_coords = []

  # find "x" coords
  (0..bottom).each do |row|
    (0..right).each do |col|
      puts "Checking Grid for X: (#{row}, #{col})"
      if grid[row][col] == 'X'
        x_coords.push([row, col, 4])
        puts "X found at #{row}, #{col}"
      end
    end
  end

  puts "Xs: #{x_coords.size}"
  m_coords = findNext(grid, left, top, right, bottom, 'M', x_coords) unless x_coords.empty?

  puts "Ms: #{m_coords.size}"
  a_coords = findNext(grid, left, top, right, bottom, 'A', m_coords) unless m_coords.empty?

  puts "As: #{a_coords.size}"
  s_coords = findNext(grid, left, top, right, bottom, 'S', a_coords) unless a_coords.empty?

  puts "Ss: #{s_coords.size}"
  s_coords.size
end

def findNext(grid, left, top, right, bottom, letter, coordinates)
  found_coords = []

  coordinates.each do |coord|
    count = 0
    ((coord[0] - 1)..(coord[0] + 1)).each do |row|
      ((coord[1] - 1)..(coord[1] + 1)).each do |col|
        unless row < top || row > bottom || col < left || col > right
          puts "Checking Grid for #{letter} because of root (#{coord[0]}, #{coord[1]}): (#{row}, #{col}). Prior: #{coord[2]} Current: #{count}"
          if grid[row][col] == letter && (count == coord[2] || coord[2] == 4)
            found_coords.push([row, col, count])
            puts "#{letter} found at #{row}, #{col}"
          end
        end
        count += 1
      end
    end
  end

  found_coords
end

input = '../Inputs/input1.txt'
puzzle = populateWordSearch(input)

left_boundary = 0
top_boundary = 0
right_boundary = puzzle[0].size - 1
bottom_boundary = puzzle.size - 1

count_xmas_in_puzzle = findOccurances(puzzle, left_boundary, top_boundary, right_boundary, bottom_boundary)

puts count_xmas_in_puzzle
puts puzzle[9][8]
puts puzzle[9][9]
