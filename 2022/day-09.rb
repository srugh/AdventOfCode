require 'set'
def parse_input(path)
  File.read(path).split(/\n/).map{|chunk| chunk.split}
end

def solve_part_1(input)
  dirs = Hash.new
  dirs["U"] = [-1, 0]
  dirs["D"] = [1, 0]
  dirs["R"] = [0, 1]
  dirs["L"] = [0,-1]

  visited = Set.new

  start = [0, 0]
  head = start
  tail = start
  visited.add(tail)

  input.each_with_index do |move, idx|
    d = move[0]
    steps = move[1].to_i
  
    steps.times do
      head = [head[0]+dirs[d][0], head[1]+dirs[d][1]]

      if tailsmove?(head, tail, dirs)
        dx = head[0] - tail[0]
        dy = head[1] - tail[1]
        tail = [tail[0] + (dx <=> 0), tail[1] + (dy <=> 0)]
        visited.add(tail)
      end
    end
  end
  visited.size
end

def tailsmove?(head, tail, dirs)
  (head[0] - tail[0]).abs > 1 || (head[1] - tail[1]).abs > 1
end

def solve_part_2(input)
  
end


path = "Inputs/day-09.txt"
#path = "Inputs/day-09-sample.txt"
input = parse_input(path)
part_1 = solve_part_1(input)
part_2 = solve_part_2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"