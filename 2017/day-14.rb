# frozen_string_literal: true

DIRS = [
  [0, 1],
  [0, -1],
  [1, 0],
  [-1, 0]
].freeze
def solve_part1(input)
  str = "#{input}-"
  count = 0
  128.times do |i|
    count += calc_knot_hash(str + i.to_s).to_i(16).to_s(2).rjust(128, '0').count('1')
  end
  count
end

def calc_knot_hash(str)
  lengths = str.bytes + [17, 31, 73, 47, 23]
  s    = (0...256).to_a
  cur  = 0
  skip = 0
  size = s.size

  64.times do
    lengths.each do |l|
      (0...(l / 2)).each do |i|
        a = (cur + i) % size
        b = (cur + l - 1 - i) % size
        s[a], s[b] = s[b], s[a]
      end

      cur = (cur + l + skip) % size
      skip += 1
    end
  end

  # dense hash
  s.each_slice(16)
   .map { |block| block.reduce(:^).to_s(16).rjust(2, '0') }
   .join
end

def bfs(graph, start)
  queue = [[start[0], start[1]]]
  head = 0

  graph[start[0]][start[1]] = 0

  total_rows = graph.size
  total_cols = graph[0].size

  while head < queue.size
    r, c = queue[head]
    head += 1

    DIRS.each do |dr, dc|
      nr = r + dr
      nc = c + dc

      next unless nr.between?(0, total_rows - 1) && nc.between?(0, total_cols - 1)
      next unless graph[nr][nc] == 1

      graph[nr][nc] = 0
      queue << [nr, nc]
    end
  end
end

def solve_part2(input)
  str = "#{input}-"
  grid = []
  128.times do |i|
    grid.push(calc_knot_hash(str + i.to_s).hex.to_s(2).rjust(128, '0').chars.map! { |c| c == '1' ? 1 : 0 })
  end

  count = 0

  grid.each_with_index do |row, r|
    row.each_with_index do |cell, c|
      next if cell.zero?

      bfs(grid, [r, c])
      count += 1
    end
  end
  count
end

input = 'nbysizxe'
puts "part 1: #{solve_part1(input)}"
puts "part 2: #{solve_part2(input)}"
