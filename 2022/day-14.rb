# frozen_string_literal: true

def parse_input(path)
  lines = []
  File.readlines(path, chomp: true).each do |l|
    chunks = l.split(' -> ')
    line = chunks.map do |chunk|
      chunk.split(',').map(&:to_i)
    end
    lines << line
  end
  lines
end

def solve_part1(line_groups)
  graph, bottom_max = create_graph(line_groups)
  sand_start = [500, 0]

  sand_x = 0
  sand_y = 0
  dirs_x = [0, -1, 1]
  dy = 1
  count = 0

  loop do
    dir_idx = 0
    dirs_x[dir_idx]
    sand_x, sand_y = sand_start

    while dir_idx <= 2
      dx = dirs_x[dir_idx]

      unless graph[[sand_x + dx, sand_y + dy]].zero?
        dir_idx += 1
        next
      end

      sand_x += dx
      sand_y += dy
      dir_idx = 0

      # pretty_print(graph) if sand_y > bottom_max
      return count if sand_y > bottom_max
    end
    count += 1
    graph[[sand_x, sand_y]] = 2
  end
  false
end

def create_graph(line_groups)
  graph = Hash.new { 0 }
  bottom_max = 0
  line_groups.each do |line_points|
    p_x, p_y = line_points[0]
    bottom_max = p_y if p_y > bottom_max

    (1...line_points.size).each do |i|
      c_x, c_y = line_points[i]
      bottom_max = c_y if c_y > bottom_max

      if p_x == c_x
        y = [p_y, c_y]
        (y.min..y.max).each do |j|
          graph[[p_x, j]] = 1
        end
      else
        x = [p_x, c_x]
        (x.min..x.max).each do |j|
          graph[[j, p_y]] = 1
        end
      end
      p_x = c_x
      p_y = c_y
    end
  end
  [graph, bottom_max]
end

def solve_part2(line_groups)
  graph, bottom_max = create_graph(line_groups)
  sand_start = [500, 0]

  sand_x = 0
  sand_y = 0
  dirs_x = [0, -1, 1]
  dy = 1
  count = 0

  loop do
    # pretty_print(graph) unless graph[[500, 0]] == 0
    return count unless graph[[500, 0]].zero?

    dir_idx = 0
    dirs_x[dir_idx]
    sand_x, sand_y = sand_start

    while dir_idx <= 2
      dx = dirs_x[dir_idx]
      unless graph[[sand_x + dx, sand_y + dy]].zero? && sand_y <= bottom_max
        dir_idx += 1
        next
      end
      sand_x += dx
      sand_y += dy
      dir_idx = 0
    end
    count += 1
    graph[[sand_x, sand_y]] = 2
  end
  false
end

def pretty_print(graph)
  print "\n"
  (0..165).each_with_index do |_row, y|
    (0..520).each_with_index do |_cel, x|
      print '.' if graph[[x, y]].zero?
      print '#' if graph[[x, y]] == 1
      print 'o' if graph[[x, y]] == 2
      print '~' if graph[[x, y]] == 3
    end
    print "\n"
  end
  print "\n"
end

file = 'Inputs/day-14.txt'
line_points = parse_input(file)
puts "part 1: #{solve_part1(line_points)}"
puts "part 2: #{solve_part2(line_points)}"
