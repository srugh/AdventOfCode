# frozen_string_literal: true

def parse_input(path)
  File.readlines(path, chomp: true).map(&:chars)
end

def solve_part1(grid)
  graph = Hash.new { |hash, key| hash[key] = 0 }
  c_row = grid.size / 2
  c_col = grid[0].size / 2
  c_facing = 'u'
  dirs = { 'u' => [-1, 0], 'd' => [1, 0], 'l' => [0, -1], 'r' => [0, 1] }
  turns = Hash.new { |hash, key| hash[key] = {} }
  turns['l']['u'] = 'l'
  turns['l']['l'] = 'd'
  turns['l']['d'] = 'r'
  turns['l']['r'] = 'u'
  turns['r']['u'] = 'r'
  turns['r']['l'] = 'u'
  turns['r']['d'] = 'l'
  turns['r']['r'] = 'd'
  infections = 0

  grid.each_with_index do |row, r|
    row.each_with_index do |cell, c|
      graph[[r, c]] = 1 if cell == '#'
      graph[[r, c]] = 0 if cell == '.'
    end
  end

  10_000.times do
    if graph[[c_row, c_col]] == 1
      c_facing = turns['r'][c_facing]
      graph[[c_row, c_col]] = 0
    else
      c_facing = turns['l'][c_facing]
      graph[[c_row, c_col]] = 1
      infections += 1
    end
    dr, dc = dirs[c_facing]
    c_row += dr
    c_col += dc
  end
  infections
end

def solve_part2(grid)
  graph = Hash.new { |hash, key| hash[key] = 0 }
  c_row = grid.size / 2
  c_col = grid[0].size / 2
  c_facing = 'u'
  dirs = { 'u' => [-1, 0], 'd' => [1, 0], 'l' => [0, -1], 'r' => [0, 1] }
  turns = Hash.new { |hash, key| hash[key] = {} }
  turns['l']['u'] = 'l'
  turns['l']['l'] = 'd'
  turns['l']['d'] = 'r'
  turns['l']['r'] = 'u'
  turns['r']['u'] = 'r'
  turns['r']['l'] = 'u'
  turns['r']['d'] = 'l'
  turns['r']['r'] = 'd'
  infections = 0

  grid.each_with_index do |row, r|
    row.each_with_index do |cell, c|
      graph[[r, c]] = 1 if cell == '#'
      graph[[r, c]] = 0 if cell == '.'
    end
  end

  # 0 clean, 1 infected, 2 flagged, 3 weakended
  10_000_000.times do
    case graph[[c_row, c_col]]
    when 1
      c_facing = turns['r'][c_facing]
      graph[[c_row, c_col]] = 2
    when 0
      c_facing = turns['l'][c_facing]
      graph[[c_row, c_col]] = 3

    when 2
      c_facing = turns['l'][c_facing]
      c_facing = turns['l'][c_facing]
      graph[[c_row, c_col]] = 0
    when 3
      graph[[c_row, c_col]] = 1
      infections += 1
    end
    dr, dc = dirs[c_facing]
    c_row += dr
    c_col += dc
  end
  infections
end
path = 'inputs/day-22.txt'
grid = parse_input(path)
puts "part 1: #{solve_part1(grid)}"
puts "part 2: #{solve_part2(grid)}"
