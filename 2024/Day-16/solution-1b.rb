require 'set'

# Constants for the maze
WALL = '#'
PATH = '.'

# Directions for movement
DIRECTIONS = [
  { dx: -1, dy: 0 },  # North
  { dx: 0, dy: 1 },   # East
  { dx: 1, dy: 0 },   # South
  { dx: 0, dy: -1 }   # West
]

# Helper method to parse the input file and extract the grid, start, and end points
def parse_input(file_name)
  grid = []
  start_idx = nil
  end_idx = nil

  File.readlines(file_name, chomp: true).each_with_index do |line, x|
    grid << line.chars
    line.chars.each_with_index do |char, y|
      start_idx = { x: x, y: y } if char == 'S'
      end_idx = { x: x, y: y } if char == 'E'
    end
  end

  [grid, start_idx, end_idx]
end

# Breadth-first search (BFS) to find all optimal paths
def bfs(grid, start_idx, end_idx)
    min_score = Float::INFINITY
    queue = []
    visited = {}
    size_to_indices = Hash.new { |h, k| h[k] = [] }

    # Initial state
    queue << start_idx

    until queue.empty?
        curr_state = queue.shift

        # Debugging the current state
        puts "Processing state: #{curr_state}"

        # Prune paths that are already worse than the best found
        #next if curr_state[:score] > min_score

        # Check if we reached the end
        if curr_state == end_idx
            next
        end

    # Process neighbors
    get_neighbors(curr_state[:reindeer]).each do |neighbor|
      # Skip walls
      next if grid[neighbor[:idx][:x]][neighbor[:idx][:y]] == WALL

      # Calculate score
      score = curr_state[:score] + 1
      score += 1000 if curr_state[:reindeer][:dir] != neighbor[:dir]

      # Debugging score calculation
      puts "Neighbor: #{neighbor}, Score: #{score}, Current Min Score: #{min_score}"

      # Skip if already visited with a better score
      if visited[neighbor] && visited[neighbor] <= score
        next
      end

      visited[neighbor] = score

      # Add the new state to the queue
      queue << {
        reindeer: neighbor,
        path: curr_state[:path] + [neighbor[:idx]],
        score: score
      }
    end
  end

  count_map = Set.new
  size_to_indices[min_score].each { |idx| count_map.add(idx) }

  [min_score, count_map.size]
end

# Get all valid neighbors for the current node
def get_neighbors(reindeer)
  neighbors = []
  curr_dir = reindeer[:dir]
  curr_idx = reindeer[:idx]
  opposite_dir = { dx: -curr_dir[:dx], dy: -curr_dir[:dy] }

  DIRECTIONS.each do |dir|
    next if dir == opposite_dir  # Skip the opposite direction

    n_idx = { x: curr_idx[:x] + dir[:dx], y: curr_idx[:y] + dir[:dy] }
    neighbors << { idx: n_idx, dir: dir }
  end

  neighbors
end

# Main program
  input_file = "Inputs/sample.txt" # Change to your input file
  grid, start_idx, end_idx = parse_input(input_file)

  part1, part2 = bfs(grid, start_idx, end_idx)

  puts "Part One: #{part1}" # Expected score
  puts "Part Two: #{part2}" # Number of unique tiles visited by optimal paths

