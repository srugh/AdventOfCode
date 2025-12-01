require 'json'

def parse_input(path)
  File.read(path)
end

def solve_part_1(input)
  total = 0
  input.scan(/(-?\d+)/).flatten.each do |num|
    total += num.to_i
  end
  total
end

def solve_part_2(node)

  case node
  when Integer
    node
  when Array
    node.sum { |v| solve_part_2(v) }
  when Hash
    # If any value is exactly "red", ignore the whole object
    return 0 if node.values.include?("red")
    node.values.sum { |v| solve_part_2(v) }
  else
    0
  end
end



path = "Inputs/day-12.txt"
input = parse_input(path)
part_1 = solve_part_1(input)

data = JSON.parse(File.read(path))

puts "part_1: #{part_1}"
puts solve_part_2(data)