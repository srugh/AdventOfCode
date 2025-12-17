# frozen_string_literal: true

def parse_input(file)
  patterns = []
  File.readlines(file, chomp: true).each do |line|
    parts = line.split
    start = parts[2].split(',')
    area = parts[3].split('x')
    start_row = start[1]
    start_col = start[0]
    start_row[start_row.length - 1] = ''

    patterns.push([start_row.to_i, start_col.to_i, area[1].to_i, area[0].to_i])
  end
  patterns
end

def pretty_print_grid(grid)
  grid.each_with_index do |row, _r_idx|
    row.each_with_index do |col, _c_idx|
      print col
    end
    print "\n"
  end
  print "\n"
end

def calc_overlaps(patterns)
  grid = Array.new(1000) { Array.new(1000, 0) }
  overlap = 0

  patterns.each do |pattern|
    grid = update_grid(grid, pattern)
  end

  grid.each_with_index do |row, r|
    row.each_with_index do |_col, c|
      overlap += 1 if grid[r][c] > 1
    end
  end

  patterns.each_with_index do |pattern, idx|
    next if claim_overlaps?(grid, pattern)

    p pattern

    puts "part_2: #{idx + 1}"
  end

  overlap
end

def claim_overlaps?(grid, pattern)
  overlap = false

  start_r, start_c, height, width = pattern
  height.times do |r_idx|
    width.times do |c_idx|
      return true if grid[start_r + r_idx][start_c + c_idx] > 1
    end
  end
  overlap
end

def update_grid(grid, pattern)
  start_r, start_c, height, width = pattern
  height.times do |r_idx|
    width.times do |c_idx|
      grid[start_r + r_idx][start_c + c_idx] += 1
    end
  end

  grid
end

file = 'Inputs/day-03.txt'

patterns = parse_input(file)
overlaps = calc_overlaps(patterns)

puts "part_1: total overlaps is #{overlaps}"
