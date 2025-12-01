require 'set'

def parse_input(input_file)
    grid = []
    File.readlines(input_file, chomp:true).each do |line|
        grid.push(line.chars)
    end

    grid
end

def pretty_print_grid(grid, path=[])
    puts ""
    grid.each_with_index do |row, r|
        row.each_with_index do |col, c|
            if path.include?([r,c])
                print "X"
            else
                print col
            end
        end
        print "\n"
    end 
    print "\n\n"
end

def find_initial_positions(grid)
    start_pos = []
    final_pos = []

    grid.each_with_index do |row, r_idx|
        row.each_with_index do |col, c_idx|
            start_pos = [r_idx, c_idx] if col == "S"
            final_pos = [r_idx, c_idx] if col == "E"

            return [start_pos, final_pos] if start_pos.size > 0 && final_pos.size > 0
        end
    end
end

def is_wall?(grid, pos)
   #puts "wall check: #{pos[0]}, #{pos[1]}"
    return true if grid[pos[0]][pos[1]] == "#"
    
    false
end

def dfs_path(grid, start_pos, end_pos)
    queue = []
    visited = Set.new
    dirs = [[0,1], [0,-1], [1,0], [-1,0]]

    visited.add(start_pos)

    queue << [start_pos, [start_pos]]

    while queue.size > 0
        cur_pos, path = queue.shift
        #visited.add(cur_pos)

        #p cur_pos
        #p visited
        return path if cur_pos == end_pos

        dirs.each do |dir|
            next_pos = [cur_pos[0]+dir[0], cur_pos[1]+dir[1]]
            #puts "next pos"
            #p next_pos
            if !is_wall?(grid, next_pos) && !visited.include?(next_pos)
                queue << [next_pos, path + [next_pos]]
                visited.add(next_pos)
            end
        end

    end
    return nil
end

def generate_cheat_maps(grid, path)
    dirs = [[0,1], [0,-1], [1,0], [-1,0]]
    remove_walls = Set.new
    path.each do |pos|
        dirs.each do |dir|
            next_pos = [pos[0] + dir[0], pos[1] + dir[1]]
            next_pos_x_2 = [next_pos[0] + dir[0], next_pos[1] + dir[1]]

            # Boundary checks
            if next_pos_x_2[0].between?(0, grid.size - 1) && next_pos_x_2[1].between?(0, grid[0].size - 1)
               
                if is_wall?(grid, next_pos)
                    if !is_wall?(grid, next_pos_x_2)
                        # Case 1: next_pos is wall and next_pos_x_2 is track
                        #puts "pos: (#{pos[0]}, #{pos[1]})   removing: (#{next_pos[0]}, #{next_pos[1]})"
                        remove_walls.add(next_pos)
                    elsif is_wall?(grid, next_pos_x_2) && has_adjacent_track?(grid, next_pos_x_2)
                        # Case 2: next_pos and next_pos_x_2 are walls, but next_pos_x_2 has an adjacent track
                        #puts "pos: (#{pos[0]}, #{pos[1]})   removing: (#{next_pos[0]}, #{next_pos[1]}) with two walls"
                        remove_walls.add(next_pos)
                    end
                end
            end
        end
    end
    remove_walls
end


def has_adjacent_track?(grid, pos)
    dirs = [[0,1], [0,-1], [1,0], [-1,0]]
    dirs.any? do |dir|
        adjacent_pos = [pos[0] + dir[0], pos[1] + dir[1]]
        # Ensure the adjacent position is within grid boundaries
        if adjacent_pos[0].between?(0, grid.size - 1) && adjacent_pos[1].between?(0, grid[0].size - 1)
            grid[adjacent_pos[0]][adjacent_pos[1]] == '.' || grid[adjacent_pos[0]][adjacent_pos[1]] == 'S' || grid[adjacent_pos[0]][adjacent_pos[1]] == 'E'
        else
            false
        end
    end
end

def deep_copy_grid(grid)
    grid.map { |row| row.dup }
end

def calc_cheat_paths(grid, remove_walls, start, final, path_size, input_file)
    loc_grid = []
    fast_cheats = 0
    remove_walls.each_with_index do |wall, idx|
        puts "removing wall: #{idx}"
        loc_grid = deep_copy_grid(grid)
        loc_grid[start[0]][start[1]] = "S"
        loc_grid[wall[0]][wall[1]] = "O"
        loc_grid[final[0]][final[1]] = "E"
        #puts "wall that was removed: #{wall[0]}, #{wall[1]}"
        
        path = dfs_path(loc_grid, start, final)
        #pretty_print_grid(loc_grid, path)
        #puts "cheat path size delta: #{path_size - path.size - 1 }"
        if path_size - (path.size - 1) >= 2
            #puts "cheat path size delta: #{path_size - path.size-1 }"
            fast_cheats += 1
        end
    end

    fast_cheats
end

def calc_fast_cheat_paths(grid, input_file)
    path =[]
    start_pos = []
    final_pos = []
    remove_walls = Set.new
    fast_cheats = 0

    start_pos, final_pos = find_initial_positions(grid)
    puts "start: #{start_pos} \t final: #{final_pos}"

    path = dfs_path(grid, start_pos, final_pos)
    puts "dfs_path_size: #{path.size-1}"
    p path
    #pretty_print_grid(grid, path)

    remove_walls = generate_cheat_maps(grid, path)
    puts "remove_walls.size: #{remove_walls.size}"
    #p remove_walls

    fast_cheats = calc_cheat_paths(grid, remove_walls, start_pos, final_pos, path.size-1, input_file)

    fast_cheats
end
input_file = "Inputs/sample.txt"
#input_file = "Inputs/input.txt"

grid = []
fast_cheats = 0

grid = parse_input(input_file)
fast_cheats = calc_fast_cheat_paths(grid, input_file)

puts "fast_cheats: #{fast_cheats}"
#pretty_print_grid(grid)