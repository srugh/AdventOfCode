def parse_input(path)
  File.read(path).split(//).map {|i| i.to_i}
end

def solve_part_1(input)
  pattern = [0, 1, 0, -1]
end

path = "Inputs/day-16.txt"
input = parse_input(path)
puts solve_part_1(input)