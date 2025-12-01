require 'io/console'

def parse_input(input_file)
    maze =[]

    File.readlines(input_file, chomp: true).each do |line|
        maze.push(line.chars)
    end

    maze
end

def pretty_print_grid(grid)
    grid.each do |row|
        row.each do |col|
            print col
        end
        print "\n"
    end 
    print "\n"
end


def calc_shortest_path_score(maze)
    start_pos = []
    solved_paths = []
    solved_path_scores = []
    best_score = 0
    
    #find start
    puts "find start"
    start_pos = find_start(maze)

    #find paths
    puts "starting to solve with: #{start_pos}"
    solved_paths = solve_maze(maze, start_pos)

    #calc path costs
    best_path, best_score = calc_path_score(maze, solved_paths)

    #return shortest path's score
    best_score
end

def find_start(maze)
    maze.each_with_index do |row, r_idx|
        row.each_with_index do |col, c_idx|
            if col == "S"
                return [r_idx, c_idx]
            end
        end
    end
end

def is_wall?(maze, next_pos)
    return true unless (maze[next_pos[0]][next_pos[1]] == "." || maze[next_pos[0]][next_pos[1]] == "E")
    
    false
end

def found_end?(maze, cur_pos)
    return true if maze[cur_pos[0]][cur_pos[1]] == "E"

    false
end

def move(maze, cur_pos, facing)

    
end

def turn_right(facing)
    case facing
    when "E" 
        return "S"
    when "N"
        return "E"
    when "S"
        return "W"
    when "W"
        return "N"
    end 
end

def get_delta(facing)
    case facing
    when "E" 
        return [0,1]
    when "N"
        return [-1,0]
    when "S"
        return [1,0]
    when "W"
        return [0,-1]
    end
end

def solve_maze(maze, cur_pos, visited = [], memo = {})

    memo_key = [cur_pos, visited.sort]
    return memo[memo_key] if memo.key?(memo_key)

    if found_end?(maze, cur_pos)
        memo[memo_key] = [[cur_pos]]
        return memo[memo_key]
    end
    #return [[cur_pos]] if found_end?(maze, cur_pos)

    visited << cur_pos  
    dirs = ["E", "S", "W", "N"]
    all_paths = []

    dirs.each do |dir|
        delta = get_delta(dir)

        next_pos = [cur_pos[0] + delta[0], cur_pos[1] + delta[1]]


        next if is_wall?(maze, next_pos) || visited.include?(next_pos)
        
        paths_from_next = solve_maze(maze, next_pos, visited.dup)
        paths_from_next.each do |path|
            all_paths << [cur_pos] + path
        end
    end
    memo[memo_key] = all_paths
    all_paths
end

def calc_path_score(maze, solved_paths)
    best_score = 9999999999
    best_path = []
    facing = "E"
    move_pts = 1
    turn_pts = 1000

    total_turns = 0

    solved_paths.each_with_index do |path, id|
        facing = "E"
        total_turns = 0
        path.each_with_index do |cur_pos, idx|
            break if found_end?(maze, cur_pos)

            next_pos = path[idx+1]
            facing, turns = turn(cur_pos, next_pos, facing)
            total_turns += turns
        end
        score = total_turns * turn_pts + (path.size - 1) * 1
        puts "Path id: #{id}: #{score}"
        if score < best_score
            best_score = score
            best_path = path
        end
    end

    [best_path, best_score]
end

def turn(cur_pos, next_pos, facing)
    
    dirs = ["E", "S", "W", "N"]
    next_dir = ""
    turns = 0
    # direction of next pos relative to cur pos
    dirs.each do |dir|
        delta = get_delta(dir)
        if (cur_pos[0]+delta[0] == next_pos[0]) && (cur_pos[1]+delta[1] == next_pos[1])
            next_dir = dir
            break
        end
    end

    if facing == next_dir
        turns = 0
    elsif facing == "N"
        if next_dir == "S"
            turns = 2
        else
            turns = 1
        end
    elsif facing == "S"
        if next_dir == "N"
            turns = 2
        else
            turns = 1
        end
    elsif facing == "E"
        if next_dir == "W"
            turns = 2
        else
            turns = 1
        end
    elsif facing == "W"
        if next_dir == "E"
            turns = 2
        else
            turns = 1
        end
    end

    [next_dir, turns]
end
##################################################################

input_file = "Inputs/sample.txt"
#input_file = "Inputs/input.txt"

maze = []


maze = parse_input(input_file)
# pretty_print_grid(maze)
best_score = calc_shortest_path_score(maze)

puts "Best score: #{best_score}"

#pretty_print_grid(maze)