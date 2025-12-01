require 'set'
def parse_input(path)
  File.read(path).split(/\n/).map{|chunk| chunk.split}
end

def solve_part_1(input)
  system = Hash.new
  cwd = ""
  parent = ""
  system["/"] = []
  while input.size > 0
    cmd = input.shift


    if cmd[1] == "cd"
      if cmd[2] == ".."
        system[cwd].each do |f|
          if f[0] == "parent"
            cwd = f[1]
          end
          break
        end
      elsif cmd[2] == "/"
        cwd = "/"
      else
  
        system[cmd[2]].push(["parent", cwd])
        cwd = cmd[2]
      end
      next
    end

    if cmd[1] == "ls"
      while input.size > 0 && input.first[0] != "$"
        file = input.shift
  
        if file[0] == "dir"
          system[cwd].push(["dir", file[1], cwd])
          system[file[1]] = []
        else
     
          system[cwd].push(["file", file[1], file[0].to_i])
        end
      end
    end

  end
 
  dir_sizes = Hash.new 
  leaf_dirs = Set.new
  system.each do |k, v|
    dir_sizes[k] = 0
    has_dir = false
    v.each do |f|
      if f[0] == "file"
        dir_sizes[k] += f[2]
      end
      if f[0] == "dir"
        has_dir = true
      end
    end
    leaf_dirs.add(k) if !has_dir
  end

  
  leaf_dirs.each do |dir|
    node = system[dir]
    chain = []
      node.each do |f|
        if f[0] == "parent"
          
        end
      end
    end

end

def solve_part_2(input)
  
end


path = "Inputs/day-07.txt"
input = parse_input(path)
part_1 = solve_part_1(input)
part_2 = solve_part_2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"