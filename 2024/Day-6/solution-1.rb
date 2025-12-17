# frozen_string_literal: true

def populate_grid(input_file)
  grid = []
  File.foreach(input_file) do |line|
    grid.push(line.chomp.chars)
  end

  grid
end

def find_initial_knight_position(grid)
  position = []

  (0..(grid.size - 1)).each do |row|
    (0..(grid[0].size - 1)).each do |col|
      if grid[row][col] == '^'
        position = [row, col]
        break
      end
    end
  end
  position
end

def knight_move_one_step(grid, knight_position, knight_in_grid, knight_facing)
  cur_row = knight_position[0]
  cur_col = knight_position[1]

  case knight_facing
  when 'up'
    return knight_position, false, 'up' if cur_row.zero?

    if grid[cur_row - 1][cur_col] == '#'
      knight_facing = 'right'
    elsif grid[cur_row - 1][cur_col] == '.'
      knight_position = [cur_row - 1, cur_col]
    end

  when 'down'
    return knight_position, false, 'down' if cur_row == grid.size - 1

    if grid[cur_row + 1][cur_col] == '#'
      knight_facing = 'left'
    elsif grid[cur_row + 1][cur_col] == '.'
      knight_position = [cur_row + 1, cur_col]
    end

  when 'left'
    return knight_position, false, 'left' if cur_col.zero?

    if grid[cur_row][cur_col - 1] == '#'
      knight_facing = 'up'
    elsif grid[cur_row][cur_col - 1] == '.'
      knight_position = [cur_row, cur_col - 1]
    end

  when 'right'
    return knight_position, false, 'right' if cur_col == grid[0].size - 1

    if grid[cur_row][cur_col + 1] == '#'
      knight_facing = 'down'
    elsif grid[cur_row][cur_col + 1] == '.'
      knight_position = [cur_row, cur_col + 1]
    end
  end
  [knight_position, knight_in_grid, knight_facing]
end

def count_steps(grid, _left_boundary, _top_boundary, _right_boundary, _bottom_boundary)
  knight_position = find_initial_knight_position(grid)
  grid[knight_position[0]][knight_position[1]] = '.'
  knight_facing = 'up'
  knight_in_grid = true
  # knight_positions_visited = []
  # knight_positions_visited = Array.new(grid.size){Array.new(grid[0].size)}
  knight_positions_visited = Array.new(grid.size) { Array.new(grid[0].size) }

  knight_positions_visited[knight_position[0]][knight_position[1]] = 1

  count = 0
  while knight_in_grid
    puts "\nIteration: #{count}"
    puts "before:: pos: #{knight_position} \t facing: #{knight_facing} \t in-grid: #{knight_in_grid}"
    knight_position, knight_in_grid, knight_facing = knight_move_one_step(grid, knight_position, knight_in_grid,
                                                                          knight_facing)
    knight_positions_visited[knight_position[0]][knight_position[1]] = 1 if knight_in_grid == true
    puts "after:: pos: #{knight_position} \t facing: #{knight_facing} \t in-grid: #{knight_in_grid}"
    count += 1
  end

  knight_positions_visited.flatten.count(1)
end

input = 'Inputs/input1.txt'
# input = "Inputs/sample.txt"
grid = populate_grid(input)

left_boundary = 0
top_boundary = 0
right_boundary = grid[0].size - 1
bottom_boundary = grid.size - 1

knight_steps = count_steps(grid, left_boundary, top_boundary, right_boundary, bottom_boundary)

puts "total unique steps: #{knight_steps}"
