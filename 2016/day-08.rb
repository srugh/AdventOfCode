# frozen_string_literal: true

def parse_input(path)
  input = []
  File.readlines(path, chomp: true).each do |line|
    chunks = line.split
    if chunks[0] == 'rect'
      x = chunks[1].split('x').map(&:to_i)
      input.push([chunks[0], x[0], x[1]])
    elsif chunks[0] == 'rotate'
      x = chunks[2].split('=')
      input.push([chunks[0], chunks[1], x[1].to_i, chunks[4].to_i])
    end
  end
  input
end

def solve_part1(input)
  rows = 6
  cols = 50
  grid = Array.new(rows) { Array.new(cols, false) }

  input.each do |action|
    _, c, r = action if action[0] == 'rect'
    _, type, target, amount = action if action[0] == 'rotate'

    if action[0] == 'rect'
      r.times do |row|
        c.times do |col|
          grid[row][col] = true
        end
      end
    else
      cache = []
      if type == 'column'
        rows.times do |i|
          pos_to_0 = (rows - amount + i) % rows
          cache.push(grid[pos_to_0][target])
        end
        rows.times do |i|
          grid[i][target] = cache.shift
        end
      else
        cols.times do |i|
          pos_to_0 = (cols - amount + i) % cols
          cache.push(grid[target][pos_to_0])
        end
        cols.times do |i|
          grid[target][i] = cache.shift
        end
      end
    end
  end
  count = 0
  grid.each do |rows|
    rows.each do |col|
      count += col ? 1 : 0
    end
  end
  pretty_print(grid)
  count
end

def pretty_print(grid)
  grid.each do |rows|
    rows.each do |col|
      val = col ? '#' : ' '
      print val
    end
    print "\n"
  end
end

path = 'Inputs/day-08.txt'
input = parse_input(path)
p solve_part1(input)
