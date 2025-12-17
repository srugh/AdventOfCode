# frozen_string_literal: true

ADJ_LOCS = [
  [-1, -1], [0, -1], [1, -1],
  [-1, 0], [1, 0],
  [-1, 1], [0, 1], [1, 1]
].freeze

def parse_input(path)
  File.readlines(path, chomp: true).map(&:chars)
end

def solve_part1(grid)
  moveable_total = 0
  tot_rows = grid.size
  tot_cols = grid[0].size
  grid.each_with_index do |row, r|
    row.each_with_index do |pos, c|
      next unless pos == '@'

      adj_count = 0
      ADJ_LOCS.each do |adj|
        a_r, a_c = adj
        next if (r + a_r).negative? || r + a_r > tot_rows - 1
        next if (c + a_c).negative? || c + a_c > tot_cols - 1

        adj_count += 1 if grid[r + a_r][c + a_c] == '@'
        break if adj_count == 4
      end
      moveable_total += 1 if adj_count < 4
    end
  end
  moveable_total
end

def solve_part2(grid)
  moveable_total = 0
  while (moveable = remove_rolls(grid)).positive?
    moveable_total += moveable
  end
  moveable_total
end

def remove_rolls(grid)
  moveable_total = 0
  tot_rows = grid.size
  tot_cols = grid[0].size
  grid.each_with_index do |row, r|
    row.each_with_index do |pos, c|
      next unless pos == '@'

      adj_count = 0
      ADJ_LOCS.each do |adj|
        a_r, a_c = adj
        next if (r + a_r).negative? || r + a_r > tot_rows - 1
        next if (c + a_c).negative? || c + a_c > tot_cols - 1

        adj_count += 1 if grid[r + a_r][c + a_c] == '@'
        break if adj_count == 4
      end
      if adj_count < 4
        moveable_total += 1
        grid[r][c] = '.'
      end
    end
  end
  moveable_total
end

path = 'Inputs/day-04.txt'
grid = parse_input(path)

puts "part 1: #{solve_part1(grid)}"
puts "part 2: #{solve_part2(grid)}"
