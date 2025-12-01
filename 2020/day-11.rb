def parse_input(path)
  grid = []
  File.foreach(path) do |line|
      grid.push(line.chomp.split(//)) 
  end
  
  grid
end

def solve_part_1(grid)
  pending_changes = []
  empty = "L"
  floor = "."
  occupied = "#"
  round = 0

  tot_rows = grid.size
  tot_cols = grid[0].size
  
  dirs = Hash.new
  dirs["nw"] = [-1, -1]
  dirs["n"]  = [-1, 0]
  dirs["ne"] = [-1, 1]
  dirs["w"]  = [0, -1]
  dirs["e"]  = [0, 1]
  dirs["sw"] = [1, -1]
  dirs["s"]  = [1, 0]
  dirs["se"] = [1, 1]

  while round == 0 || pending_changes.size > 0
    
    if pending_changes.size > 0
      #commit_changes(grid, pending_changes)
      pending_changes = []
    end
    #p grid
    # calc changes
    grid.each_with_index do |rows, r|
      rows.each_with_index do |cols, c|
        #puts grid[r][c]
        if grid[r][c] == floor
          next
        elsif grid[r][c] == empty
          if should_occupy?(grid, [r, c], dirs)
            pending_changes.push(["occupy", r, c])
          end
        elsif grid[r][c] == occupied
          if should_free?(grid, [r, c], dirs)
            pending_changes.push(["free", r, c])
          end
        end
      end
    end

    #p pending_changes
    pending_changes.each do |change|
      r = change[1]
      c = change[2]
      if change[0] == "occupy"
        grid[r][c] = "#"
      elsif change[0] == "free"
        grid[r][c] = "L"
      end
    end
    # prep next round
    round += 1
  end
  total = 0
  grid.each_with_index do |rows, r|
    rows.each_with_index do |cols, c|
      if grid[r][c] == "#"
        total += 1
      end
    end
  end
  total
end

def should_occupy?(grid, seat, dirs)
  dirs.each do |k, v|
    check = [seat, v].transpose.map { |x, y| x + y }
    if check[0] >= 0 && check[0] < grid.size && check[1] >= 0 && check[1] < grid[0].size
      if grid[check[0]][check[1]] == "#"
        return false
      end
    end
  end
  true
end

def should_free?(grid, seat, dirs)
  count = 0
  dirs.each do |k, v|
    check = [seat, v].transpose.map { |x, y| x + y }
    if check[0] >= 0 && check[0] < grid.size && check[1] >= 0 && check[1] < grid[0].size
      if grid[check[0]][check[1]] == "#"
        count += 1
      end
    end
  end
  count >= 4 ? true : false
end

def solve_part_2(grid)
  pending_changes = []
  empty = "L"
  floor = "."
  occupied = "#"
  round = 0


  
  dirs = Hash.new
  dirs["nw"] = [-1, -1]
  dirs["n"]  = [-1, 0]
  dirs["ne"] = [-1, 1]
  dirs["w"]  = [0, -1]
  dirs["e"]  = [0, 1]
  dirs["sw"] = [1, -1]
  dirs["s"]  = [1, 0]
  dirs["se"] = [1, 1]

  while round == 0 || pending_changes.size > 0
  
    
    if pending_changes.size > 0
   
      pending_changes = []
    end
 
    # calc changes
    grid.each_with_index do |rows, r|
      rows.each_with_index do |cols, c|
     
        if grid[r][c] == floor
          next
        elsif grid[r][c] == empty
          if should_occupy_2?(grid, [r, c], dirs)
            pending_changes.push(["occupy", r, c])
          end
        elsif grid[r][c] == occupied
          if should_free_2?(grid, [r, c], dirs)
            pending_changes.push(["free", r, c])
          end
        end
      end
    end


    pending_changes.each do |change|
      r = change[1]
      c = change[2]
      if change[0] == "occupy"
        grid[r][c] = "#"
      elsif change[0] == "free"
        grid[r][c] = "L"
      end
    end
    # prep next round
    round += 1
  end
  total = 0
  grid.each_with_index do |rows, r|
    rows.each_with_index do |cols, c|
      if grid[r][c] == "#"
        total += 1
      end
    end
  end
  total
  
end

def should_occupy_2?(grid, seat, dirs)
  dirs.each do |k, v|
    check = [seat, v].transpose.map { |x, y| x + y }
    while check[0] >= 0 && check[0] < grid.size && check[1] >= 0 && check[1] < grid[0].size
      
      if grid[check[0]][check[1]] == "#"
        return false
      end
      if grid[check[0]][check[1]] == "L"
        break
      end
      check = [check, v].transpose.map { |x, y| x + y }
    end
  end
  true
end

def should_free_2?(grid, seat, dirs)
  count = 0
 
  dirs.each do |k, v|
    check = [seat, v].transpose.map { |x, y| x + y }
    while check[0] >= 0 && check[0] < grid.size && check[1] >= 0 && check[1] < grid[0].size
  
      if grid[check[0]][check[1]] == "#"
        count += 1
        break
      end
      if grid[check[0]][check[1]] == "L"
       
        break
      end
      check = [check, v].transpose.map { |x, y| x + y }
    end
  end
  count >= 5 ? true : false
end

path = "Inputs/day-11.txt"


grid = parse_input(path)

#part_1 = solve_part_1(grid)
part_2 = solve_part_2(grid)

#puts "part_1: #{part_1}"
puts "part_2: #{part_2}"