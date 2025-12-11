BOX = [
    [0,0], [1,0], [2,0],
    [0,1], [1,1], [2,1],
    [0,2], [1,2], [2,2]
]

def solve_part_1(serial_number)
  grid_size = 300
  grid =  Array.new(grid_size) { Array.new(grid_size, 0) }

  (1..grid_size).each do |y|
    (1..grid_size).each do |x|
      rack_id = x + 10
      power_level = rack_id * y 
      power_level += serial_number
      power_level *= rack_id
      power_level = power_level >= 100 ? power_level.to_s[-3].to_i: 0
      power_level -= 5
      grid[x-1][y-1] = power_level
    end
  end

  largest = -Float::INFINITY
  largest_top_left = []

  (0...grid_size-2).each do |y|
    (0...grid_size-2).each do |x|
      total_power = 0
      BOX.each do |dx,dy|
        total_power += grid[x+dx][y+dy]
      end
      if total_power > largest 
        largest = total_power
        largest_top_left = [x+1,y+1]
      end
    end
  end
  p largest
  p largest_top_left
end

def solve_part_2(serial_number)
  grid_size = 300
  grid =  Array.new(grid_size) { Array.new(grid_size, 0) }

  (1..grid_size).each do |y|
    (1..grid_size).each do |x|
      rack_id = x + 10
      power_level = rack_id * y 
      power_level += serial_number
      power_level *= rack_id
      power_level = power_level >= 100 ? power_level.to_s[-3].to_i: 0
      power_level -= 5
      grid[x-1][y-1] = power_level
    end
  end

  prefix = Array.new(grid_size+1) { Array.new(grid_size+1, 0) }

  (0...grid_size).each do |x|
    col_sum = 0
    (0...grid_size).each do |y|
      col_sum += grid[x][y]
      prefix[x+1][y+1] = prefix[x][y+1] + col_sum
    end
  end
  
  largest = -Float::INFINITY
  largest_top_left = []
  largest_box_size = nil
  

  (1..grid_size).each do |size|
    limit = grid_size - size + 1
    (0...limit).each do |y|
      (0...limit).each do |x|
      
        total = prefix[x+size][y+size] - prefix[x][y+size] - prefix[x+size][y] + prefix[x][y]
        if total > largest
          largest = total
          largest_top_left = [x+1,y+1]
          largest_box_size = size
        end
      end
    end
  end

  "#{largest_top_left[0]},#{largest_top_left[1]},#{largest_box_size}"
end

serial_number = 5235

puts "part 1: #{solve_part_1(serial_number)}"
puts "part 2: #{solve_part_2(serial_number)}"