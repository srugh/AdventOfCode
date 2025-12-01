
def solve_part_1(fav_num, target)
  x, y = target
  grid = Array.new(1, [])

  p bfs_grid(grid, 1, 1, y, x, fav_num)

end


def solve_part_2(fav_num, steps)

  grid = Array.new(1, [])

  p bfs_grid_2(grid, 1, 1, steps, fav_num)

end

def bfs_grid(grid, y, x, target_y, target_x, fav_num)
  step = 0
  # Directions for moving to adjacent cells (up, down, left, right)
  directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  # Walkable values
  walkable = [["."]]

  # Queue to store cells to visit, along with their distance from the start
  queue = [[y, x, 0]] # [row, col, distance]

  # Set to store visited cells to avoid cycles and redundant processing
  visited = Set.new
  visited.add([y, x])


  while !queue.empty?

    current_y, current_x, distance = queue.shift
    
    # Check if the target is reached
    if current_y == target_y && current_x == target_x
      return distance
    end

    # Explore neighbors
    directions.each do |dr, dc|
      new_y = current_y + dr
      new_x = current_x + dc
    
      # Check if the new cell is within grid boundaries and not an obstacle (e.g., 0)
      if new_y >= 0 && new_x >= 0 
        if new_y > grid.size - 1
          0.upto(new_y) do
            grid.push([])
          end
        end

        if grid[new_y] == nil
          0.upto(new_x) do |i|
            grid[new_y].push(calc_loc(new_y, i, fav_num, grid))
          end
        end
        if new_x > grid[new_y].size - 1
          grid[new_y].push([])
        end

        if grid[new_y][new_x] != ["#"] && grid[new_y][new_x] != ["."]
          grid[new_y][new_x] = calc_loc(new_x, new_y, fav_num, grid)
        end

        if walkable.include?(grid[new_y][new_x]) && # Assuming 1 represents a traversable cell
         !visited.include?([new_y, new_x])
          visited.add([new_y, new_x])
          queue.push([new_y, new_x, distance + 1])
        end
      end
    end
    step += 1
  end

  # If the target is not reachable
  return -1
end

def calc_loc(x, y, fav_num, memo)

  # Find x*x + 3*x + 2*x*y + y + y*y.
  calc = x*x + 3*x + 2*x*y + y + y*y

  # Add the office designer's favorite number (your puzzle input).
  calc += fav_num

  # Find the binary representation of that sum; count the number of bits that are 1.
  calc_binary = calc.to_s(2)

  # If the number of bits that are 1 is even, it's an open space.
  # If the number of bits that are 1 is odd, it's a wall.
  return calc_binary.count("1").even? ? ["."] : ["#"]
end

def pretty_print(grid)
  grid.each do |rows|
    rows.each do |col|
      val = col.first if col != nil
      if val == nil
        val = "_"
      end
      print val
    end
    print "\n"
  end
end


def bfs_grid_2(grid, y, x, steps, fav_num)
 
  # Directions for moving to adjacent cells (up, down, left, right)
  directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  # Walkable values
  walkable = [["."]]

  # Queue to store cells to visit, along with their distance from the start
  queue = [[y, x, 0]] # [row, col, distance]

  # Set to store visited cells to avoid cycles and redundant processing
  visited = Set.new
  visited.add([y, x])


  while !queue.empty?

    current_y, current_x, distance = queue.shift
    next if distance == steps

    # Explore neighbors
    directions.each do |dr, dc|
      new_y = current_y + dr
      new_x = current_x + dc
    
      # Check if the new cell is within grid boundaries and not an obstacle (e.g., 0)
      if new_y >= 0 && new_x >= 0 
        if new_y > grid.size - 1
          0.upto(new_y) do
            grid.push([])
          end
        end

        if grid[new_y] == nil
          0.upto(new_x) do |i|
            grid[new_y].push(calc_loc(new_y, i, fav_num, grid))
          end
        end
        if new_x > grid[new_y].size - 1
          grid[new_y].push([])
        end

        if grid[new_y][new_x] != ["#"] && grid[new_y][new_x] != ["."]
          grid[new_y][new_x] = calc_loc(new_x, new_y, fav_num, grid)
        end

        if walkable.include?(grid[new_y][new_x]) && # Assuming 1 represents a traversable cell
         !visited.include?([new_y, new_x])
          visited.add([new_y, new_x])
          queue.push([new_y, new_x, distance + 1])
        end
      end
    end

  end
  visited.size
end


fav_num = 1362
target = [31, 39]
steps = 50

solve_part_1(fav_num, target)
solve_part_2(fav_num, steps)