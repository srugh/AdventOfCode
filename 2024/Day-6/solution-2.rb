require 'set'

def populate_grid(input_file)
    grid = []
    File.foreach(input_file) do |line|
        grid.push(line.chomp.split(//)) 
    end
  
    grid
end

def find_initial_knight_position(grid)
    position = []

    for row in 0..grid.size-1
        for col in 0..grid[0].size-1
            if grid[row][col] == "^"
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

    if knight_facing == "up"
        if cur_row == 0
            return knight_position, false, "up"
        end

        if grid[cur_row-1][cur_col] == "#"
            knight_facing = "right"
        elsif grid[cur_row-1][cur_col] == "." || grid[cur_row-1][cur_col] == "^"
            knight_position = [cur_row-1, cur_col]
        end

    elsif knight_facing == "down"
        if cur_row == grid.size-1
            return knight_position, false, "down"
        end

        if grid[cur_row+1][cur_col] == "#"
            knight_facing = "left"
        elsif grid[cur_row+1][cur_col] == "." || grid[cur_row+1][cur_col] == "^"
            knight_position = [cur_row+1, cur_col]
        end

    elsif knight_facing == "left"
        if cur_col == 0
            return knight_position, false, "left"
        end

        if grid[cur_row][cur_col-1] == "#"
            knight_facing = "up"
        elsif grid[cur_row][cur_col-1] == "." || grid[cur_row][cur_col-1] == "^"
            knight_position = [cur_row, cur_col-1]
        end

    elsif knight_facing == "right"
        if cur_col == grid[0].size-1
            return knight_position, false, "right"
        end

        if grid[cur_row][cur_col+1] == "#"
            knight_facing = "down"
        elsif grid[cur_row][cur_col+1] == "." || grid[cur_row][cur_col+1] == "^"
            knight_position = [cur_row, cur_col+1]
        end
    end
    [knight_position, knight_in_grid, knight_facing]
end

def knight_looped?(grid)
    knight_position = find_initial_knight_position(grid)
 
    knight_facing = "up"
    knight_in_grid = true
    #knight_positions_visited = []
    #knight_positions_visited = Array.new(grid.size){Array.new(grid[0].size)}
    knight_positions_visited = Set.new 

    knight_positions_visited.add([knight_position, knight_facing])

    count = 0
    looped = false
    while knight_in_grid && looped == false
        #puts "\nIteration: #{count}"
        #puts "before:: pos: #{knight_position} \t facing: #{knight_facing} \t in-grid: #{knight_in_grid}"
        knight_position, knight_in_grid, knight_facing = knight_move_one_step(grid, knight_position, knight_in_grid, knight_facing)
        if knight_in_grid == true
            if knight_positions_visited.include?([knight_position, knight_facing])
                looped = true
            end
            knight_positions_visited.add([knight_position, knight_facing])
        end
        #puts "after:: pos: #{knight_position} \t facing: #{knight_facing} \t in-grid: #{knight_in_grid}"
        count += 1

    end

    looped
end

def find_blockages(input)
    looped_count = 0
    grid = populate_grid(input)
    count = 0
    for row in 0..grid.size-1
        for col in 0..grid[0].size-1
            puts "#{count+1}/#{grid.flatten.size}"
            count += 1
            
            if grid[row][col] == "."
                grid = populate_grid(input)
                grid[row][col] = "#"
                if knight_looped?(grid)
                    looped_count += 1
                end
              
            end
        end
    end
    looped_count
end


input = "Inputs/input1.txt"
#input = "Inputs/sample.txt"
#grid = populate_grid(input)


loops = find_blockages(input)

puts "total unique steps: #{loops}"