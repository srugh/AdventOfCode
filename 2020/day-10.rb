def parse_input(path)
  File.read(path).split(/\n/)
    .map { |chunk| chunk.to_i}
    .sort
end

def solve_part_1(numbers)
  cur = 0
  tally = [0, 0, 0, 0]

  numbers.each do |number|
    tally[number-cur] += 1
    cur = number
  end
  tally[3] += 1
  return (tally[1] * tally[3])
end

file = "Inputs/day-10.txt"

numbers = parse_input(file)

part_1 = solve_part_1(numbers)
#part_2 = solve_part_2(numbers)

puts "part 1: #{part_1}"
#puts "part 2: #{part_2}"