require 'set'

def load_grid(input_file)
  File.readlines(input_file, chomp: true).map { |line| line.chars.map(&:to_i) }
end

def calc_paths(grid)
  trail_heads = find_trail_heads(grid)
  find_paths(trail_heads, grid)
end

def find_trail_heads(grid)
  trail_heads = []
  grid.each_with_index do |row, row_idx|
    row.each_with_index do |value, col_idx|
      trail_heads << [row_idx, col_idx] if value == 0
    end
  end
  trail_heads
end

def is_valid?(cur_pos, next_pos, grid)
  within_bounds = next_pos[0].between?(0, grid.size - 1) &&
                  next_pos[1].between?(0, grid[0].size - 1)

  increments_one = within_bounds &&
                   grid[next_pos[0]][next_pos[1]] == grid[cur_pos[0]][cur_pos[1]] + 1

  within_bounds && increments_one
end

def find_paths(trail_heads, grid)
  directions = [[0, 1], [0, -1], [1, 0], [-1, 0]]
  total_scores = 0

  trail_heads.each do |trail_head|
    visited = Set.new
    queue = [trail_head]
    reachable_nines = Set.new

    while !queue.empty?
      cur_pos = queue.shift
      visited.add(cur_pos)

      directions.each do |dir|
        next_pos = [cur_pos[0] + dir[0], cur_pos[1] + dir[1]]

        if is_valid?(cur_pos, next_pos, grid) && !visited.include?(next_pos)
          queue << next_pos
          visited.add(next_pos)

          if grid[next_pos[0]][next_pos[1]] == 9
            reachable_nines.add(next_pos)
          end
        end
      end
    end

    total_scores += reachable_nines.size
  end

  total_scores
end

# Main Program
#input_file = "Inputs/sample.txt"
input_file = "Inputs/input1.txt"
grid = load_grid(input_file)
complete_paths = calc_paths(grid)
puts "Complete paths: #{complete_paths}"
