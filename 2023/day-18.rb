# frozen_string_literal: true

def parse_file(path)
  File.readlines(path, chomp: true).map(&:split).map { |c| [c[0], c[1].to_i, c[2]] }
end

DIRS = {}.freeze
DIRS['R'] = [1, 0]
DIRS['L'] = [-1, 0]
DIRS['U'] = [0, -1]
DIRS['D'] = [0, 1]

def solve_part1(plan)
  graph = Hash.new { 0 }
  start = [0, 0]
  graph[start] = 1
  x, y = start
  max_x = 0
  max_y = 0
  min_x = min_y = Float::INFINITY
  plan.each do |dir, times, _|
    dx, dy = DIRS[dir]
    times.times do
      x += dx
      y += dy
      max_x = x if x > max_x
      max_y = y if y > max_y
      min_x = x if x < min_x
      min_y = y if y < min_y
      graph[[x, y]] = 1
    end
  end

  pt = find_internal_point(graph, max_x, max_y, min_x, min_y)
  p pt
  # bfs(graph, pt, max_x, max_y)
  graph.select { |_k, v| v == 1 }.size
  # pretty_print(graph, max_y, max_x, min_x, min_y)
end

def find_internal_point(graph, max_x, max_y, min_x, min_y)
  puts min_x, max_x
  moves = [[0, 1], [0, -1], [1, 0], [-1, 0]]
  count = 0
  (min_y..max_y).each do |y|
    count += 1
    return if count == 5

    count2 = 0
    (min_x..max_x).each do |x|
      count2 += 1
      # p graph[[x, y]]
      puts graph[[x, y]] if count2 > 183 && count2 < 186
      next if graph[[x, y]] == 1

      idx = 0
      move = moves[idx]
      dx, dy = move
      nxt_x = x
      nxt_y = y
      found = false
      while nxt_y <= max_y
        if graph[[nxt_x, nxt_y]] == 1
          found = true
          idx += 1
          break
        end
        nxt_x += dx
        nxt_y += dy
      end
      break unless found

      move = moves[idx]
      dx, dy = move
      nxt_x = x
      nxt_y = y
      found = false
      puts "x: #{x}, y: #{y}"

      # p graph[[x,y]]
      # p move
      while nxt_y >= min_y
        # p graph[[nxt_x, nxt_y]]
        puts "nxt_x: #{nxt_x}, nxt_y: #{nxt_y}"

        if graph[[nxt_x, nxt_y]] == 1
          found = true
          idx += 1
          break
        end
        nxt_x += dx
        nxt_y += dy
      end
      break unless found

      move = moves[idx]
      dx, dy = move
      nxt_x = x
      nxt_y = y
      found = false
      p '2'
      while nxt_x <= max_x
        if graph[[nxt_x, nxt_y]] == 1
          found = true
          idx += 1
          break
        end
        nxt_x += dx
        nxt_y += dy
      end
      break unless found

      move = moves[idx]
      dx, dy = move
      nxt_x = x
      nxt_y = y
      # p move
      # p idx
      while nxt_x >= min_x
        return [x, y] if graph[[nxt_x, nxt_y]] == 1

        # p dx
        nxt_x += dx
        nxt_y += dy
      end
    end
  end
  'you fucked up'
end

def bfs(graph, start, max_x, max_y)
  # p start

  queue = [start] # Queue for BFS
  visited = Set.new([start]) # Set to store visited points
  # reachable_coords = [] # Array to store results
  reachable = 0
  # Define possible moves (dx, dy)
  moves = [[0, 1], [0, -1], [1, 0], [-1, 0]]

  until queue.empty?
    current_x, current_y = queue.shift # Get the next point
    # reachable_coords << [current_x, current_y]
    reachable += 1
    graph[[current_x, current_y]] = 1

    moves.each do |dx, dy|
      next_x = current_x + dx
      next_y = current_y + dy

      # Check boundaries and if it's a valid, unvisited spot (not an obstacle 'X')
      next unless next_x.between?(0, max_x) && next_y.between?(0, max_y) &&
                  graph[[next_x, next_y]].zero? && !visited.include?([next_x, next_y])

      visited.add([next_x, next_y])
      queue << [next_x, next_y]
    end
  end
  # reachable_coords.size
  reachable
end

def pretty_print(graph, rows, cols, min_x, min_y)
  puts rows
  puts cols
  puts min_y
  puts min_x
  count = 0
  (min_y..rows).each do |y|
    (min_x..cols).each do |x|
      val = graph[[x, y]]
      if count == 1 && val == 1
        puts
        puts x + min_x.abs
        puts
      end

      print('.') if val.zero?
      print('#') if val == 1
    end
    print("\n")
    count += 1
  end
  puts
  true
end

path = 'Inputs/day-18.txt'
plan = parse_file(path)
puts "part 1: #{solve_part1(plan)}"
