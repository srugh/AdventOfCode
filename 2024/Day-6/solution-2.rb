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
    elsif ['.', '^'].include?(grid[cur_row - 1][cur_col])
      knight_position = [cur_row - 1, cur_col]
    end

  when 'down'
    return knight_position, false, 'down' if cur_row == grid.size - 1

    if grid[cur_row + 1][cur_col] == '#'
      knight_facing = 'left'
    elsif ['.', '^'].include?(grid[cur_row + 1][cur_col])
      knight_position = [cur_row + 1, cur_col]
    end

  when 'left'
    return knight_position, false, 'left' if cur_col.zero?

    if grid[cur_row][cur_col - 1] == '#'
      knight_facing = 'up'
    elsif ['.', '^'].include?(grid[cur_row][cur_col - 1])
      knight_position = [cur_row, cur_col - 1]
    end

  when 'right'
    return knight_position, false, 'right' if cur_col == grid[0].size - 1

    if grid[cur_row][cur_col + 1] == '#'
      knight_facing = 'down'
    elsif ['.', '^'].include?(grid[cur_row][cur_col + 1])
      knight_position = [cur_row, cur_col + 1]
    end
  end
  [knight_position, knight_in_grid, knight_facing]
end

def knight_looped?(grid)
  knight_position = find_initial_knight_position(grid)

  knight_facing = 'up'
  knight_in_grid = true
  # knight_positions_visited = []
  # knight_positions_visited = Array.new(grid.size){Array.new(grid[0].size)}
  knight_positions_visited = Set.new

  knight_positions_visited.add([knight_position, knight_facing])

  count = 0
  looped = false
  while knight_in_grid && looped == false
    # puts "\nIteration: #{count}"
    # puts "before:: pos: #{knight_position} \t facing: #{knight_facing} \t in-grid: #{knight_in_grid}"
    knight_position, knight_in_grid, knight_facing = knight_move_one_step(grid, knight_position, knight_in_grid,
                                                                          knight_facing)
    if knight_in_grid == true
      looped = true if knight_positions_visited.include?([knight_position, knight_facing])
      knight_positions_visited.add([knight_position, knight_facing])
    end
    # puts "after:: pos: #{knight_position} \t facing: #{knight_facing} \t in-grid: #{knight_in_grid}"
    count += 1

  end

  looped
end

def find_blockages(input)
  looped_count = 0
  grid = populate_grid(input)
  count = 0
  (0..(grid.size - 1)).each do |row|
    (0..(grid[0].size - 1)).each do |col|
      puts "#{count + 1}/#{grid.flatten.size}"
      count += 1

      next unless grid[row][col] == '.'

      grid = populate_grid(input)
      grid[row][col] = '#'
      looped_count += 1 if knight_looped?(grid)
    end
  end
  looped_count
end

input = 'Inputs/input1.txt'
# input = "Inputs/sample.txt"
# grid = populate_grid(input)

loops = find_blockages(input)

puts "total unique steps: #{loops}"
