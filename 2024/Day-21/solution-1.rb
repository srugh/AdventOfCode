require 'set'

def parse_input(input_file)
    codes = []
    File.readlines(input_file, chomp: true).each do |code|
        codes.push(code.chars)
    end
    codes
end

def calc_complexities(codes, num_pad, dir_pad)
    num_min_dists = Hash.new
    dir_min_dists = Hash.new
    num_min_paths = Hash.new
    dir_min_paths = Hash.new

    input_sizes = []

    num_min_dists, num_min_paths = calc_min_dists(num_pad)
    dir_min_dists, dir_min_paths = calc_min_dists(dir_pad)

    

    codes.each do |code|
        size = calc_code_complexity(code, num_pad, dir_pad, num_min_dists, dir_min_dists, num_min_paths, dir_min_paths)
        code_num = (code[0] + code[1] + code[2]).to_i
        input_sizes.push(size+code_num)
    end
    
    input_sizes.sum
end

def calc_code_complexity(code, num_pad, dir_pad, num_min_dists, dir_min_dists, num_min_paths, dir_min_paths)
    num_path = []
    
    # num pad path
    prev = "A"
    code.each_with_index do |button, idx|
        unless button == "A"
            if idx == 0
                num_path.push( num_min_paths[[prev, button]])
            else
                num_path.append( (num_min_paths[[prev, button]]).drop(1))
            end
            num_path.append( (num_min_paths[[button, "A"]]).drop(1))
            #prev = button
        end
    end

    flat_num_path = []
    num_path.each do |row|
        row.each do |cell|  
            flat_num_path.append([cell[0], cell[1]])
        end
    end
   
    


    
    # dir pad path
    
    # dir pad path
    
    # dir pad path
    
end

def calc_min_dists(grid)
    min_dists = Hash.new
    min_paths = Hash.new

    grid.each_with_index do |start_row, sr|
        start_row.each_with_index do |start_col, sc|
            grid.each_with_index do |end_row, er|
                end_row.each_with_index do |end_col, ec|
                    unless (sr == er && sc == ec) || grid[sr][sc] == "#"
                        min_path = bfs_path(grid, [sr, sc], [er, ec])
                        unless min_path == nil
                            min_dists[[grid[sr][sc], grid[er][ec]]] = min_path.size - 1
                            min_paths[[grid[sr][sc], grid[er][ec]]] = min_path
                        end
                    end
                end
            end
        end       
    end
    [min_dists, min_paths]
end

def is_wall?(grid, pos)
    r,c = pos
    return grid[r][c] == "#"
end

def in_grid?(grid, pos)
    r,c = pos
    if r >= 0 && r < grid.size && c >= 0 && c < grid[0].size
        return true
    end
    false
end

def bfs_path(grid, start_pos, end_pos)
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
            if in_grid?(grid, next_pos)
                if !is_wall?(grid, next_pos) && !visited.include?(next_pos)
                    queue << [next_pos, path + [next_pos]]
                    visited.add(next_pos)
                end
            end
        end

    end
    return nil
end




########################################
## Setup
########################################

def create_input_grids()
    num_pad = []
    dir_pad = []

    num_pad.push(["7", "8", "9"])
    num_pad.push(["4", "5", "6"])
    num_pad.push(["1", "2", "3"])
    num_pad.push(["#", "0", "A"])

    dir_pad.push(["#", "^", "A"])
    dir_pad.push(["<", "v", ">"])

    [num_pad, dir_pad]
end

input_file = "Inputs/sample.txt"
#input_file = "Inputs/input.txt"

codes = []
num_pad = []
dir_pad = []

num_pad, dir_pad = create_input_grids()

codes = parse_input(input_file)
complexity_sum = calc_complexities(codes, num_pad, dir_pad)

puts "complexity sum: #{complexity_sum}"