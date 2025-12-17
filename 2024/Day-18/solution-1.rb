# frozen_string_literal: true

def parse_input(input_file)
  bytes = []
  File.readlines(input_file, chomp: true).each do |line|
    coords = line.split(',')
    bytes.push([coords[0].to_i, coords[1].to_i])
  end

  bytes
end

def pretty_print_grid(grid, path = [])
  p path
  grid.each_with_index do |row, r_idx|
    row.each_with_index do |col, c_idx|
      if path.include?([r_idx, c_idx])
        print 'O'
      else
        print col
      end
    end
    print "\n"
  end
  print "\n"
end

def drop_bytes(bytes, num_bytes, grid)
  num_bytes.times.each do |idx|
    grid[bytes[idx][1]][bytes[idx][0]] = '#'
  end

  grid
end

def calc_min_path(grid, start_pos, end_pos)
  queue = []
  visited = Set.new
  dirs = [[0, 1], [0, -1], [1, 0], [-1, -0]]

  visited.add(start_pos)

  queue << [start_pos, [start_pos]]

  while queue.size.positive?
    cur_pos, path = queue.shift
    # visited.add(cur_pos)

    # p cur_pos
    # p visited
    return path if cur_pos == end_pos

    dirs.each do |dir|
      next_pos = [cur_pos[0] + dir[0], cur_pos[1] + dir[1]]
      # puts "next pos"
      # p next_pos
      if valid_pos?(grid, next_pos) && !visited.include?(next_pos)
        queue << [next_pos, path + [next_pos]]
        visited.add(next_pos)
      end
    end

  end
  nil
end

def valid_pos?(grid, pos)
  row = pos[0]
  col = pos[1]

  # pos in grid
  if row.negative? || row >= grid.size || col.negative? || col >= grid[0].size
    p pos
    return false
  end

  # pos not wall

  return false if grid[row][col] == '#'

  true
end

def calc_best_path_size(bytes, num_bytes, grid_size)
  grid = []

  # grid.push(hor_wall)
  grid_size.times do
    row = Array.new(grid_size, '.')
    grid.push(row)
  end

  start_pos = [0, 0]
  end_pos = [grid_size - 1, grid_size - 1]
  puts end_pos
  grid = drop_bytes(bytes, num_bytes, grid)
  min_path = calc_min_path(grid, start_pos, end_pos)

  pretty_print_grid(grid, min_path)
  min_path.size - 1
end

input_file = 'Inputs/input.txt'
num_bytes = 0
grid_size = 0
real = true

if real
  input_file = 'Inputs/input.txt'
  num_bytes = 1024
  grid_size = 71
else
  input_file = 'Inputs/sample.txt'
  num_bytes = 12
  grid_size = 7
end

bytes = parse_input(input_file)
min_steps = calc_best_path_size(bytes, num_bytes, grid_size)

puts "Min steps: #{min_steps}"
