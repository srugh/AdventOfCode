def parse_input(path)
   File.read(path).split(",").map(&:to_i)
end

def solve_part_1(input)
  median = 0

  sorted_arr = input.sort
  mid = sorted_arr.length / 2

  if sorted_arr.length.even?
    median = (sorted_arr[mid - 1] + sorted_arr[mid]).to_f / 2
  else
    median = sorted_arr[mid]
  end
  gas = 0
  input.each do |fish|
    gas += (fish - median).abs
  end
  gas
end

def solve_part_2(input)
  mean_floor = (input.sum / input.size.to_f).floor
  mean_ceiling = (input.sum / input.size.to_f).ceil
 
  gas_floor = 0
  gas_ceiling = 0
  input.each do |fish|
    steps_floor = (fish - mean_floor).abs
    gas_floor += (steps_floor * (steps_floor + 1)) / 2

    steps_ceiling= (fish - mean_ceiling).abs
    gas_ceiling += (steps_ceiling * (steps_ceiling + 1)) / 2
  end
  [gas_floor, gas_ceiling].min
end


path = "Inputs/day-07.txt"
input = parse_input(path)
#input = [16,1,2,0,4,2,7,1,2,14]
part_1 = solve_part_1(input.clone)
part_2 = solve_part_2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"