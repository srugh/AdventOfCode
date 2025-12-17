# frozen_string_literal: true

DIRS = [[1, 0], [-1, 0], [0, 1], [0, -1]].freeze

def parse_input(path)
  File.readlines(path, chomp: true).map(&:chars)
end

def bfs(graph, start, target, total_rows, total_cols)
  visited = Set.new
  queue = [[start, 0]]
  visited.add(start)

  until queue.empty?
    current, dist = queue.shift
    return dist if current == target

    DIRS.each do |dr, dc|
      nr = current[0] + dr
      nc = current[1] + dc
      nxt = [nr, nc]

      next unless nr.between?(0, total_rows - 1) && nc.between?(0, total_cols - 1)
      next if visited.include?(nxt)
      next if graph[[nr, nc]] - graph[current] > 1

      visited.add(nxt)
      queue << [nxt, dist + 1]
    end
  end
end

def solve_part1(grid)
  graph = Hash.new { 0 }
  start = target = []
  rows = grid.size
  cols = grid[0].size

  grid.each_with_index do |row, r|
    row.each_with_index do |cel, c|
      if cel == 'S'
        start = [r, c]
        graph[[r, c]] = 'a'.ord
      elsif cel == 'E'
        target = [r, c]
        graph[[r, c]] = 'z'.ord
      else
        graph[[r, c]] = cel.ord
      end
    end
  end

  bfs(graph, start, target, rows, cols)
end

def solve_part2(grid)
  graph = {}
  rows = grid.size
  cols = grid[0].size
  as = []
  grid.each_with_index do |row, r|
    row.each_with_index do |cel, c|
      if cel == 'S'

        graph[[r, c]] = 'a'.ord
        as << [r, c]
      elsif cel == 'E'

        graph[[r, c]] = 'z'.ord
      else
        graph[[r, c]] = cel.ord
        as << [r, c] if cel == 'a'
      end
    end
  end
  lens = []
  p as.size
  as.each do |start|
    len = bfs(graph, start, target, rows, cols)
    lens << len unless len.nil?
  end
  lens.min
end

path = 'Inputs/day-12.txt'
graph = parse_input(path)
puts "part 1: #{solve_part1(graph)}"
puts "part 1: #{solve_part2(graph)}"
