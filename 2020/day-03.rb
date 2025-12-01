def parse_input(file)
  grid = []
  File.foreach(file) do |line|
      grid.push(line.chomp.split(//)) 
  end
  
  grid
end

def solve_part_1(grid, slope)
  start_pos = [0,0]

  done = grid.size-1
  edge = grid[0].size-1

  trees = 0

  cur_pos = [start_pos[0] + slope[0], start_pos[1] + slope[1]]

  while cur_pos[0] <= done
    if grid[cur_pos[0]][cur_pos[1]] == "#" 
      trees += 1
    end
    next_pos = [cur_pos[0] + slope[0], (cur_pos[1] + slope[1]) % (edge+1)]
    cur_pos = next_pos
  end

  trees
end

def solve_part_2(grid)
  slopes = []
  slopes.push([1,1])
  slopes.push([1,3])
  slopes.push([1,5])
  slopes.push([1,7])
  slopes.push([2,1])

  total = []
  slopes.each do |slope|
    trees = solve_part_1(grid, slope)
    total.push(trees)
  end

  total.inject(:*)
end


#file = "Inputs/day-03.txt"
file = "Inputs/day-03-sample.txt"

grid = parse_input(file)

part_1 = solve_part_1(grid, [1,3])
part_2 = solve_part_2(grid)

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"