def parse_input(path)
   File.read(path).split(/\n\n/)
    .map {|chunk| chunk.split(/\n/).map{|i| i.to_i}}
end

def solve_part_1(input)
  totals = []
  input.each do |foods|
    totals.push(foods.sum)
  end
  totals.max
end

def solve_part_2(input)
  totals = []
  input.each do |foods|
    totals.push(foods.sum)
  end
  totals = totals.uniq.sort.reverse!

  (totals[0] + totals[1] + totals[2])
end


path = "Inputs/day-01.txt"
input = parse_input(path)
part_1 = solve_part_1(input)
part_2 = solve_part_2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"