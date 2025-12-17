# frozen_string_literal: true

def solve_part1(depth, target)
  t_x, t_y = target
  total_risk = 0
  regions = Array.new(t_x + 1) { Array.new(t_y + 1, 0) }
  (0..t_y).each do |y|
    (0..t_x).each do |x|
      index = if (x.zero? && y.zero?) || (x == t_x && y == t_y)
                0
              elsif y.zero?
                x * 16_807
              elsif x.zero?
                y * 48_271
              else
                regions[x - 1][y] * regions[x][y - 1]
              end

      erosion_level = (index + depth) % 20_183
      regions[x][y] = erosion_level
      total_risk += erosion_level % 3
    end
  end

  total_risk
end

depth = 7305
target = [13, 734]
# depth = 510
# target = [10, 10]

puts "part 1: #{solve_part1(depth, target)}"
