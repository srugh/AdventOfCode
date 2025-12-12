def solve_part_1(n)
  return 0 if n == 1

  side_len = Math.sqrt(n).ceil
  side_len += 1 if side_len.even?         # ensure odd

  radius  = side_len / 2
  max_val = side_len * side_len
  offset  = (max_val - n) % (side_len - 1)

  radius + (offset - radius).abs
end


NEIGHBOR_OFFSETS = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]

def neighbor_sum(grid, x, y)
  NEIGHBOR_OFFSETS.sum do |dx, dy|
    grid[[x + dx, y + dy]] || 0
  end
end

def solve_part_2(limit)
  grid = Hash.new(0)
  x = y = 0
  grid[[0, 0]] = 1

  dirs = [[1, 0], [0, 1], [-1, 0], [0, -1]]  # right, up, left, down
  step_len = 1
  dir_idx = 0

  loop do
    2.times do
      dx, dy = dirs[dir_idx % 4]

      step_len.times do
        x += dx
        y += dy

        val = neighbor_sum(grid, x, y)
        return val if val > limit

        grid[[x, y]] = val
      end

      dir_idx += 1
    end

    step_len += 1
  end
end

num = 368078

puts "part 1: #{solve_part_1(num)}"
puts "part 2: #{solve_part_2(num)}"