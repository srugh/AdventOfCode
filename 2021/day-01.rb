def parse_input(path)
  File.read(path).split(/\n/).map{|i| i.to_i}
end

def solve_part_1(input)
  count = 0
  input.each_with_index do |d, i|
    next if i == 0
    count += 1 if d > input[i-1]
  end
  count
end

def solve_part_2(input)
  count = 0
  comp = []

  while input.size > 0
    comp.push(input.shift)

    if comp.size == 4
      count +=1 if comp.first(3).sum < comp.last(3).sum
      comp.shift
    end
  end
  count
end


path = "Inputs/day-01.txt"
input = parse_input(path)
part_1 = solve_part_1(input)
part_2 = solve_part_2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"