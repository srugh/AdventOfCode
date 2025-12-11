def solve_part_1(depth, target)
  t_x, t_y = target
  total_risk = 0
  regions = Array.new(t_x+1) { Array.new(t_y+1, 0) } 
  (0..t_y).each do |y|
    (0..t_x).each do |x|
      index = nil

      if (x == 0 && y == 0) || (x == t_x && y == t_y)
        index = 0
      elsif y == 0
        index = x * 16807
      elsif x == 0
        index = y * 48271
      else 
        index = regions[x-1][y] * regions[x][y-1]
      end

      erosion_level = (index + depth ) % 20183
      regions[x][y] = erosion_level
      total_risk += erosion_level % 3
    end
  end


  total_risk
end

depth = 7305
target = [13, 734]
#depth = 510
#target = [10, 10]

puts "part 1: #{solve_part_1(depth, target)}"