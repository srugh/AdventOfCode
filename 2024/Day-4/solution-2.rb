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

def findOccurances(grid, _left, _top, right, bottom)
  a_coords = []

  # find "x" coords
  (1..(bottom - 1)).each do |row|
    (1..(right - 1)).each do |col|
      puts "Checking Grid for A: (#{row}, #{col})"
      if grid[row][col] == 'A'
        a_coords.push([row, col, 4])
        puts "A found at #{row}, #{col}"
      end
    end
  end
  total_cross = 0
  a_coords.each do |cord|
    a_row = cord[0]
    a_col = cord[1]
    if ((grid[a_row - 1][a_col - 1] == 'M' && grid[a_row + 1][a_col + 1] == 'S') || (grid[a_row - 1][a_col - 1] == 'S' && grid[a_row + 1][a_col + 1] == 'M')) && ((grid[a_row + 1][a_col - 1] == 'M' && grid[a_row - 1][a_col + 1] == 'S') || (grid[a_row + 1][a_col - 1] == 'S' && grid[a_row - 1][a_col + 1] == 'M'))
      total_cross += 1
    end
  end
  puts "Total Cross: #{total_cross}"
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
