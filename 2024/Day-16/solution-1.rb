# frozen_string_literal: true

require 'io/console'

def parse_input(input_file)
  File.readlines(input_file, chomp: true).map(&:chars)
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
  # find start
  puts 'find start'
  start_pos = find_start(maze)

  # find paths
  puts "starting to solve with: #{start_pos}"
  solved_paths = solve_maze(maze, start_pos)

  # calc path costs
  _, best_score = calc_path_score(maze, solved_paths)

  # return shortest path's score
  best_score
end

def find_start(maze)
  maze.each_with_index do |row, r_idx|
    row.each_with_index do |col, c_idx|
      return [r_idx, c_idx] if col == 'S'
    end
  end
end

def is_wall?(maze, next_pos)
  return true unless ['.', 'E'].include?(maze[next_pos[0]][next_pos[1]])

  false
end

def found_end?(maze, cur_pos)
  return true if maze[cur_pos[0]][cur_pos[1]] == 'E'

  false
end

def move(maze, cur_pos, facing); end

def turn_right(facing)
  case facing
  when 'E'
    'S'
  when 'N'
    'E'
  when 'S'
    'W'
  when 'W'
    'N'
  end
end

def get_delta(facing)
  case facing
  when 'E'
    [0, 1]
  when 'N'
    [-1, 0]
  when 'S'
    [1, 0]
  when 'W'
    [0, -1]
  end
end

def solve_maze(maze, cur_pos, visited = [], memo = {})
  memo_key = [cur_pos, visited.sort]
  return memo[memo_key] if memo.key?(memo_key)

  if found_end?(maze, cur_pos)
    memo[memo_key] = [[cur_pos]]
    return memo[memo_key]
  end
  # return [[cur_pos]] if found_end?(maze, cur_pos)

  visited << cur_pos
  dirs = %w[E S W N]
  all_paths = []

  dirs.each do |dir|
    delta = get_delta(dir)

    next_pos = [cur_pos[0] + delta[0], cur_pos[1] + delta[1]]

    next if is_wall?(maze, next_pos) || visited.include?(next_pos)

    paths_from_next = solve_maze(maze, next_pos, visited.dup)
    paths_from_next.each do |path|
      all_paths << ([cur_pos] + path)
    end
  end
  memo[memo_key] = all_paths
  all_paths
end

def calc_path_score(maze, solved_paths)
  best_score = 9_999_999_999
  best_path = []
  facing = 'E'
  turn_pts = 1000

  total_turns = 0

  solved_paths.each_with_index do |path, id|
    facing = 'E'
    total_turns = 0
    path.each_with_index do |cur_pos, idx|
      break if found_end?(maze, cur_pos)

      next_pos = path[idx + 1]
      facing, turns = turn(cur_pos, next_pos, facing)
      total_turns += turns
    end
    score = (total_turns * turn_pts) + ((path.size - 1) * 1)
    puts "Path id: #{id}: #{score}"
    if score < best_score
      best_score = score
      best_path = path
    end
  end

  [best_path, best_score]
end

def turn(cur_pos, next_pos, facing)
  dirs = %w[E S W N]
  next_dir = ''
  turns = 0
  # direction of next pos relative to cur pos
  dirs.each do |dir|
    delta = get_delta(dir)
    if (cur_pos[0] + delta[0] == next_pos[0]) && (cur_pos[1] + delta[1] == next_pos[1])
      next_dir = dir
      break
    end
  end

  if facing == next_dir
    turns = 0
  elsif facing == 'N'
    turns = if next_dir == 'S'
              2
            else
              1
            end
  elsif facing == 'S'
    turns = if next_dir == 'N'
              2
            else
              1
            end
  elsif facing == 'E'
    turns = if next_dir == 'W'
              2
            else
              1
            end
  elsif facing == 'W'
    turns = if next_dir == 'E'
              2
            else
              1
            end
  end

  [next_dir, turns]
end
##################################################################

input_file = 'Inputs/sample.txt'
# input_file = "Inputs/input.txt"

maze = parse_input(input_file)
# pretty_print_grid(maze)
best_score = calc_shortest_path_score(maze)

puts "Best score: #{best_score}"

# pretty_print_grid(maze)
