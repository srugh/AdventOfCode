def parse_input(path)
  grid = []
  File.foreach(path) do |line|
      grid.push(line.chomp.split(//).map{|i| i.to_i}) 
  end
  
  grid
end

def solve_part_1(grid)
  dirs = [[-1,0], [1,0], [0,-1], [0,1]]

  grid.each_with_index do |row, r|
    next if r == 0 || r == grid.size-1
    row.each_with_index do |col, c|
      next if c == 0 || c == grid[0].size
      
    end
  end


end

def solve_part_2(input)
  
end


path = "Inputs/day-08.txt"
input = parse_input(path)
part_1 = solve_part_1(input)
part_2 = solve_part_2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"