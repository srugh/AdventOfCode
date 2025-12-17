# frozen_string_literal: true

def parse_input(input, sample)
  paths = []
  File.foreach(input) do |line|
    parts = line.chomp.split
    pos = parts[0].scan(/\d+/)
    vel = parts[1].scan(/-?\d+/)
    paths.push([[pos[1].to_i, pos[0].to_i], [vel[1].to_i, vel[0].to_i]])
  end

  if sample
    row = 7
    col = 11
  else
    row = 103
    col = 101
  end
  default_value = 0
  grid = Array.new(row) { Array.new(col, default_value) }

  [paths, grid]
end

def calc_total(paths, grid)
  grid = populate_initial_grid(paths, grid)
  grid = calc_movements(paths, grid)
  calc_score(grid)
end

def calc_score(grid)
  quads = Array.new(4, 0)

  grid.each_with_index do |row, r_idx|
    row.each_with_index do |col, c_idx|
      if r_idx < grid.size / 2 && c_idx < grid[0].size / 2

        quads[0] += col
      elsif r_idx < grid.size / 2 && c_idx > grid[0].size / 2
        quads[1] += col
      elsif r_idx > grid.size / 2 && c_idx > grid[0].size / 2
        quads[2] += col
      elsif r_idx > grid.size / 2 && c_idx < grid[0].size / 2
        quads[3] += col
      end
    end
  end

  quads[0] * quads[1] * quads[2] * quads[3]
end

def calc_movements(paths, grid)
  updated_paths = []
  # 1.times do

  8300.times do |index|
    updated_paths = paths.dup
    updated_paths.each_with_index do |guard, idx|
      # if idx == 10

      cur_pos = guard[0]
      vel = guard[1]

      next_pos = calc_next(cur_pos, vel, grid.size - 1, grid[0].size - 1)

      grid[cur_pos[0]][cur_pos[1]] -= 1
      grid[next_pos[0]][next_pos[1]] += 1

      paths[idx][0] = [next_pos[0], next_pos[1]]
      # end
    end
    # if index > 7100
    puts "Index: #{index}"
    grid.each do |row|
      row.each do |col|
        if col.zero?
          print '.'
        else
          print col
        end
      end
      print "\n"
    end
    # end
  end
  grid
end

def calc_next(cur_pos, vel, rows, cols)
  next_pos = [cur_pos[0] + vel[0], cur_pos[1] + vel[1]]
  # puts "**"
  # p next_pos
  next_pos[0] += rows + 1 if next_pos[0].negative?
  next_pos[0] -= rows + 1 if next_pos[0] > rows
  next_pos[1] += cols + 1 if next_pos[1].negative?
  next_pos[1] -= cols + 1 if next_pos[1] > cols
  # p next_pos
  # puts "**"
  next_pos
end

def populate_initial_grid(paths, grid)
  paths.each do |guard|
    pos = guard[0]

    grid[pos[0]][pos[1]] += 1
  end
  grid
end
input_file = 'Inputs/input1.txt'
sample = false

paths, grid = parse_input(input_file, sample)

total = calc_total(paths, grid)

puts "Total is: #{total}"
