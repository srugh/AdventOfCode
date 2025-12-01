def parse_input(path)
  input = []
  lines = File.readlines(path, chomp:true)
  lines.each do |line|
    l = line.split
    input.push([l[0], l[1].to_i])
  end
  input
end

def solve_part_1(input)
  depth,  progress = 0, 0
  
  input.each do |i|
    d, x = i
    depth += x if d == "down"
    depth -= x if d == "up"
    progress += x if d == "forward"
  end
  (depth * progress)
end

def solve_part_2(input)
  depth, progress, aim = 0, 0, 0

  input.each do |i|
    d, x = i
    case d
    when "down"
      aim += x
    when "up"
      aim -= x
    when "forward"
      progress += x
      depth += aim * x
    end
  end
  (depth * progress)
end


path = "Inputs/day-02.txt"
input = parse_input(path)
part_1 = solve_part_1(input)
part_2 = solve_part_2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"