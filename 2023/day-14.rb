# frozen_string_literal: true

def parse_file(path)
  File.readlines(path, chomp: true).map(&:chars)
end

def solve_part1(grid)
  rows = grid.size
  cols = grid[0].size
  graph = build_graph(grid)

  (1...rows).each do |r|
    (0...cols).each do |c|
      next if graph[[r, c]].zero?
      next if graph[[r, c]] == 1

      temp_r = r - 1
      temp_r -= 1 while temp_r >= 0 && graph[[temp_r, c]].zero?
      graph[[r, c]] = 0
      graph[[temp_r + 1, c]] = 2
    end
  end

  weight = 0
  graph.select { |_k, v| v == 2 }.each_key do |r, _c|
    weight += rows - r
  end
  # pretty_print(graph, rows, cols)
  weight
end

def pretty_print(graph, rows, cols)
  puts
  (0...rows).each do |r|
    (0...cols).each do |c|
      val = graph[[r, c]]
      print('.') if val.zero?
      print('#') if val == 1
      print('O') if val == 2
    end
    print("\n")
  end
  puts
  true
end

def build_graph(grid)
  graph = Hash.new { 0 }
  grid.each_with_index do |row, r|
    row.each_with_index do |cel, c|
      graph[[r, c]] = 1 if cel == '#'
      graph[[r, c]] = 2 if cel == 'O'
    end
  end
  graph
end

path = 'Inputs/day-14.txt'
grid = parse_file(path)
puts "part 1: #{solve_part1(grid)}"
