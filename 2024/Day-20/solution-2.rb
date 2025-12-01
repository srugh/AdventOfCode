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

# Function to generate all possible subpaths for cheats
def generate_cheat_subpaths(path, max_cheat_duration)
  subpaths = []

  path.each_with_index do |start_pos, i|
    (i + 1...path.size).each do |j|
      cheat_duration = j - i
      break if cheat_duration > max_cheat_duration
      subpath = path[i..j]
      subpaths << { start: path[i], end: path[j], original_length: cheat_duration }
    end
  end

  subpaths
end

# Function to perform BFS with a step limit and allow passing through walls
def bfs_cheat_path(grid, start_pos, end_pos, step_limit)
  queue = []
  visited = Set.new
  dirs = [[0, 1], [1, 0], [0, -1], [-1, 0]] # Right, Down, Left, Up

  queue << [start_pos, 0]
  visited.add(start_pos)

  while !queue.empty?
    current, dist = queue.shift
    return dist if current == end_pos
    next if dist >= step_limit

    dirs.each do |dir|
      neighbor = [current[0] + dir[0], current[1] + dir[1]]
      next unless valid_position?(grid, neighbor)
      # Allow passing through walls during cheat paths
      # Do not check if neighbor is a wall
      next if visited.include?(neighbor)

      queue << [neighbor, dist + 1]
      visited.add(neighbor)
    end
  end

  Float::INFINITY # No path found within step_limit
end

# Function to find the indices of the subpath in the initial path
def find_subpath_indices(initial_path, start, fin)
  indices = []
  found_start = false

  initial_path.each_with_index do |pos, idx|
    if pos == start
      found_start = true
    end

    if found_start
      indices << pos
      break if pos == fin
    end
  end

  indices
end

# Function to calculate cheat savings accurately without overlapping prevention
def calculate_cheat_savings(grid, subpaths, initial_path, min_saving, max_saving, saving_factor)
  cheat_savings = Hash.new(0)

  subpaths.each_with_index do |subpath, idx|
    start = subpath[:start]
    fin = subpath[:end]
    original_length = subpath[:original_length]

    # Find the indices of the subpath in the initial path
    path_indices = find_subpath_indices(initial_path, start, fin)

    # Deep copy the grid to modify it without affecting other subpaths
    modified_grid = deep_copy_grid(grid)

    # Temporarily mark the subpath cells as walls to prevent overlapping
    # Exclude the start and end positions of the cheat
    path_indices.each do |pos|
      modified_grid[pos[0]][pos[1]] = '#' unless pos == start || pos == fin
    end

    # Find the shortest replacement path within step_limit, allowing passing through walls
    new_path_length = bfs_cheat_path(modified_grid, start, fin, 20)

    next if new_path_length == Float::INFINITY
    next if new_path_length >= original_length # Only consider cheats that shorten the path

    # Calculate savings with the defined factor
    steps_saved = original_length - new_path_length
    saving = steps_saved * saving_factor

    # Only consider cheats that save between min_saving and max_saving picoseconds
    if saving >= min_saving && saving <= max_saving
      # Round saving to the nearest integer for categorization
      rounded_saving = saving.round
      cheat_savings[rounded_saving] += 1

      # Debugging output
      puts "-> Valid Cheat: Saves #{rounded_saving} picoseconds (Steps Saved: #{steps_saved})"
      puts "   Cheat Path Indices: #{path_indices}"
    end
  end

  cheat_savings
end

# Function to deep copy the grid
def deep_copy_grid(grid)
  grid.map { |row| row.dup }
end

# Function to display the grid with cheat paths (optional, for debugging)
def pretty_print_grid_with_cheats(grid, initial_path, cheat_paths = [])
  puts "\nGrid with Cheats:"
  grid.each_with_index do |row, r|
    row.each_with_index do |cell, c|
      if initial_path.include?([r, c])
        print "X"
      elsif cheat_paths.any? { |cp| cp[:path].include?([r, c]) }
        print "*"
      else
        print cell
      end
    end
    puts
  end
  puts
end

# =========================
# Main Execution
# =========================

# Replace with your actual input file path
input_file = "Inputs/sample.txt"
# input_file = "Inputs/input.txt" # Uncomment this for the actual input

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
# Uncomment the following line to see the initial path
# pretty_print_grid_with_cheats(grid, initial_path)

# Generate all possible subpaths for cheats (up to 20 steps)
max_cheat_duration = 20
subpaths = generate_cheat_subpaths(initial_path, max_cheat_duration)
puts "Total possible subpaths for cheats (up to #{max_cheat_duration} steps): #{subpaths.size}"

# Define cheat saving parameters
min_saving = 50
max_saving = 76
saving_factor = 12.67 # picoseconds per step saved

# Calculate cheat savings
cheat_savings = calculate_cheat_savings(
  grid,
  subpaths,
  initial_path, # Pass initial_path here
  min_saving,
  max_saving,
  saving_factor
)

# Output cheat savings statistics
cheat_savings_sorted = cheat_savings.sort.to_h
cheat_savings_sorted.each do |savings, count|
  puts "There are #{count} cheats that save #{savings} picoseconds."
end

# Total number of valid cheats
fast_cheats = cheat_savings.values.sum
puts "Number of valid cheat paths (fast_cheats): #{fast_cheats}"
