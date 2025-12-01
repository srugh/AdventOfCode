
def populateWordSearch(input_file)
  grid = []
  File.foreach(input_file) do |line|
      row = []
      for i in 0..line.length-1
        row.push(line[i])
      end
      grid.push(row)
  end

  return grid
end

def findOccurances(grid, left, top, right, bottom)

 
  x_coords = []
  m_coords = []
  a_coords = []
  s_coords = []

  #find "x" coords
    for row in 1..bottom-1
        for col in 1..right-1
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
      if (grid[a_row-1][a_col-1] == "M" && grid[a_row+1][a_col+1] == "S")|| ( grid[a_row-1][a_col-1] == "S" && grid[a_row+1][a_col+1] == "M")
        if (grid[a_row+1][a_col-1] == "M" && grid[a_row-1][a_col+1] == "S")|| ( grid[a_row+1][a_col-1] == "S" && grid[a_row-1][a_col+1] == "M")
            total_cross += 1
        end
      end
    end
    puts "Total Cross: #{total_cross}"
end
input = "../Inputs/input1.txt"
puzzle = populateWordSearch(input)

left_boundary = 0
top_boundary = 0
right_boundary = puzzle[0].size-1
bottom_boundary = puzzle.size-1

count_xmas_in_puzzle = findOccurances(puzzle, left_boundary, top_boundary, right_boundary, bottom_boundary)

puts count_xmas_in_puzzle
puts puzzle[9][8]
puts puzzle[9][9]