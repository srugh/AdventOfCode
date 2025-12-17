# frozen_string_literal: true

require 'English'
def parse_input(path)
  locs = {}
  grid = []
  File.readlines(path, chomp: true).each_with_index do |line, idx|
    line.scan(/\d/) do |digit|
      locs[digit] = [idx, $LAST_MATCH_INFO.offset(0).first]
    end
    grid.push(line.chars)
  end
  [grid, locs]
end

def solve_part1(grid, locs)
  distances = Hash.new { |hash, key| hash[key] = {} }

  locs.each do |k_start, start|
    locs.each do |k_target, target|
      next if start == target

      distances[k_start][k_target] = bfs_grid(grid, start[0], start[1], target[0], target[1])
    end
  end

  p_1 = tsp(distances, locs, false)
  p_2 = tsp(distances, locs, true)

  { p_1: p_1, p_2: p_2 }
end

def bfs_grid(grid, start_row, start_col, target_row, target_col)
  rows = grid.length
  cols = grid[0].length

  # Directions for moving to adjacent cells (up, down, left, right)
  directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  # Walkable values
  walkable = ['.', '0', '1', '2', '3', '4', '5', '6', '7']

  # Queue to store cells to visit, along with their distance from the start
  queue = [[start_row, start_col, 0]] # [row, col, distance]

  # Set to store visited cells to avoid cycles and redundant processing
  visited = Set.new
  visited.add([start_row, start_col])

  until queue.empty?
    current_row, current_col, distance = queue.shift

    # Check if the target is reached
    return distance if current_row == target_row && current_col == target_col

    # Explore neighbors
    directions.each do |dr, dc|
      new_row = current_row + dr
      new_col = current_col + dc

      # Check if the new cell is within grid boundaries and not an obstacle (e.g., 0)
      next unless new_row >= 0 && new_row < rows &&
                  new_col >= 0 && new_col < cols &&
                  walkable.include?(grid[new_row][new_col]) && # Assuming 1 represents a traversable cell
                  !visited.include?([new_row, new_col])

      visited.add([new_row, new_col])
      queue.push([new_row, new_col, distance + 1])
    end
  end

  # If the target is not reachable
  -1
end

def tsp(distances, locs, roundtrip)
  # Get all nodes except the start node

  other_nodes = locs.keys.to_a - ['0']
  min_cost = Float::INFINITY
  best_route = []

  # Iterate through all permutations of the other nodes
  other_nodes.permutation.each do |permutation|
    current_route = roundtrip ? ['0'] + permutation + ['0'] : ['0'] + permutation
    current_cost = calculate_route_cost(distances, current_route)

    if current_cost < min_cost
      min_cost = current_cost
      best_route = current_route
    end
  end

  { route: best_route, cost: min_cost }
end

def calculate_route_cost(distances, route)
  cost = 0
  (0...(route.length - 1)).each do |i|
    from_node = route[i]
    to_node = route[i + 1]
    cost += distances[from_node.to_s][to_node.to_s] if from_node != to_node
  end
  cost
end

path = 'Inputs/day-24.txt'
grid, locs = parse_input(path)
p solve_part1(grid, locs)
