require 'set'

# =========================
# Helper Functions
# =========================

# Function to parse the input file and create a grid
def parse_input(input_file)
  grid = []
  File.readlines(input_file, chomp: true).each do |line|
    grid << line.chars
  end
  grid
end

# Function to find the start (S) and end (E) positions in the grid
def find_initial_positions(grid)
  start_pos = nil
  end_pos = nil

  grid.each_with_index do |row, r_idx|
    row.each_with_index do |cell, c_idx|
      start_pos = [r_idx, c_idx] if cell == 'S'
      end_pos = [r_idx, c_idx] if cell == 'E'
      return [start_pos, end_pos] if start_pos && end_pos
    end
  end

  [start_pos, end_pos]
end

# Function to check if a position is within the grid boundaries
def valid_position?(grid, pos)
  r, c = pos
  r.between?(0, grid.size - 1) && c.between?(0, grid[0].size - 1)
end

# Function to check if a cell is a wall
def is_wall?(grid, pos)
  r, c = pos
  grid[r][c] == '#'
end

# Function to perform BFS and return the shortest path and its length
def bfs_path(grid, start_pos, end_pos)
  queue = []
  visited = Set.new
  parent = {}
  dirs = [[0, 1], [1, 0], [0, -1], [-1, 0]] # Right, Down, Left, Up

  queue << start_pos
  visited.add(start_pos)

  while !queue.empty?
    current = queue.shift
    return reconstruct_path(parent, current) if current == end_pos

    dirs.each do |dir|
      neighbor = [current[0] + dir[0], current[1] + dir[1]]
      next unless valid_position?(grid, neighbor)
      next if is_wall?(grid, neighbor)
      next if visited.include?(neighbor)

      queue << neighbor
      visited.add(neighbor)
      parent[neighbor] = current
    end
  end

  nil # No path found
end

# Function to reconstruct the path from end to start using the parent hash
def reconstruct_path(parent, end_pos)
  path = [end_pos]
  current = end_pos

  while parent[current]
    current = parent[current]
    path << current
  end

  path.reverse
end

# Function to perform BFS and compute distance map from a starting position
def bfs_distance_map(grid, start_pos)
  distance_map = Array.new(grid.size) { Array.new(grid[0].size, Float::INFINITY) }
  queue = []
  visited = Set.new
  dirs = [[0, 1], [1, 0], [0, -1], [-1, 0]] # Right, Down, Left, Up

  queue << [start_pos, 0]
  visited.add(start_pos)
  distance_map[start_pos[0]][start_pos[1]] = 0

  while !queue.empty?
    current, dist = queue.shift

    dirs.each do |dir|
      neighbor = [current[0] + dir[0], current[1] + dir[1]]
      next unless valid_position?(grid, neighbor)
      next if is_wall?(grid, neighbor)
      next if visited.include?(neighbor)

      queue << [neighbor, dist + 1]
      visited.add(neighbor)
      distance_map[neighbor[0]][neighbor[1]] = dist + 1
    end
  end

  distance_map
end

# Function to generate a set of walls adjacent to the initial path
def generate_cheat_maps(grid, path)
  dirs = [[0, 1], [1, 0], [0, -1], [-1, 0]] # Right, Down, Left, Up
  removable_walls = Set.new

  path.each do |pos|
    dirs.each do |dir|
      wall = [pos[0] + dir[0], pos[1] + dir[1]]
      next unless valid_position?(grid, wall)
      next unless is_wall?(grid, wall)

      # Option 1: Remove a single wall
      adjacent_pos = [wall[0] + dir[0], wall[1] + dir[1]]
      if valid_position?(grid, adjacent_pos) && !is_wall?(grid, adjacent_pos)
        removable_walls.add(wall)
        next
      end

      # Option 2: Remove two consecutive walls
      second_wall = [adjacent_pos[0] + dir[0], adjacent_pos[1] + dir[1]]
      if valid_position?(grid, second_wall) && is_wall?(grid, second_wall)
        # Check if there's a track after the second wall
        track_after_second_wall = [second_wall[0] + dir[0], second_wall[1] + dir[1]]
        if valid_position?(grid, track_after_second_wall) && !is_wall?(grid, track_after_second_wall)
          removable_walls.add(wall)
        end
      end
    end
  end

  removable_walls
end

# Function to deep copy the grid
def deep_copy_grid(grid)
  grid.map { |row| row.dup }
end

# Corrected Function to Calculate Valid Cheat Paths Using Minimum Path Reduction
def calc_cheat_paths_correct(grid, remove_walls, start, final, distance_from_start, distance_from_end)
  fast_cheats = 0
  initial_steps = distance_from_start[final[0]][final[1]]

  return 0 if initial_steps == Float::INFINITY

  remove_walls.each do |wall|
    dirs = [[0, 1], [1, 0], [0, -1], [-1, 0]] # Right, Down, Left, Up
    min_new_path_length = Float::INFINITY

    dirs.each do |dir|
      before_wall = [wall[0] - dir[0], wall[1] - dir[1]]
      after_wall = [wall[0] + dir[0], wall[1] + dir[1]]

      next unless valid_position?(grid, before_wall) && valid_position?(grid, after_wall)

      # Check reachability
      if distance_from_start[before_wall[0]][before_wall[1]] < Float::INFINITY &&
         distance_from_end[after_wall[0]][after_wall[1]] < Float::INFINITY

        # New path length if this wall is removed
        new_path_length = distance_from_start[before_wall[0]][before_wall[1]] + 1 + distance_from_end[after_wall[0]][after_wall[1]]

        if new_path_length < min_new_path_length
          min_new_path_length = new_path_length
        end
      end
    end

    # After checking all directions for this wall, decide if it's a valid cheat
    if initial_steps - min_new_path_length >= 100
      fast_cheats += 1
    end
  end

  fast_cheats
end

# =========================
# Main Execution
# =========================

# Function to display the grid (optional, for debugging)
def pretty_print_grid(grid, path = [])
  puts "\nGrid:"
  grid.each_with_index do |row, r|
    row.each_with_index do |cell, c|
      if path.include?([r, c])
        print "X"
      else
        print cell
      end
    end
    puts
  end
  puts
end

# Replace with your actual input file path
input_file = "Inputs/sample.txt"
input_file = "Inputs/input.txt" # Uncomment this for the actual input

# Parse the input grid
grid = parse_input(input_file)

# Find start and end positions
start_pos, end_pos = find_initial_positions(grid)
puts "Start Position: #{start_pos}"
puts "End Position: #{end_pos}"

# Find the initial shortest path using BFS
initial_path = bfs_path(grid, start_pos, end_pos)

if initial_path.nil?
  puts "No path found from S to E."
  exit
end

initial_steps = initial_path.size - 1
puts "Initial shortest path steps: #{initial_steps}"
pretty_print_grid(grid, initial_path)

# Generate removable walls adjacent to the initial path
removable_walls = generate_cheat_maps(grid, initial_path)
puts "Number of removable walls: #{removable_walls.size}"
# Uncomment the following line to see the list of removable walls
# puts "Removable Walls: #{removable_walls.to_a}"

# Precompute distance maps from start and end
distance_from_start = bfs_distance_map(grid, start_pos)
distance_from_end = bfs_distance_map(grid, end_pos)

# Calculate the number of valid cheat paths using the corrected function
fast_cheats = calc_cheat_paths_correct(grid, removable_walls, start_pos, end_pos, distance_from_start, distance_from_end)
puts "Number of valid cheat paths (fast_cheats): #{fast_cheats}"
