def parse_input(path)
  File.read(path).split(/\n/).map { |s| s.chars} 
end

def parse_input_2(path)
  File.read(path).split(/\n/)
end

def solve_part_1(input)
  counts_1 = Hash.new {|hash, key| hash[key] = 0 }
  counts_0 = Hash.new {|hash, key| hash[key] = 0 }
  input.each do |binary|
    binary.each_with_index do |bit, i|
      counts_1[i] += 1 if bit == "1"   
      counts_0[i] += 1 if bit == "0"  
    end
  end

  gamma = Array.new(input[0].size)
  epsilon = Array.new(input[0].size)
  input[0].size.times do |i|
    if counts_1[i] > counts_0[i]
      gamma[i] = "1"
      epsilon[i] = "0"
    else
      gamma[i] = "0"
      epsilon[i] = "1"
    end
  end
  
  (gamma.join.to_i(2) * epsilon.join.to_i(2))
end

def solve_part_2(input)
  o2 = input.clone
  co2 = input.clone
  input[0].size.times do |i|
    most = ""
    least = ""
    temp_o2 = o2.select{|b| b[i] == "1"}
    temp_co2 = co2.select{|b| b[i] == "1"}

    if temp_o2.size >= o2.size - temp_o2.size
      most = "1"
    else
      most = "0"
    end
    if temp_co2.size < co2.size - temp_co2.size
      least = "1"
    else
      least = "0"
    end

    o2 = o2.select{|b| b[i] == most}
    if co2.size > 1
      co2 = co2.select{|b| b[i] == least}
    end
  end

  (o2.join.to_i(2) * co2.join.to_i(2))
  
end


path = "Inputs/day-03.txt"
input = parse_input(path)
input2 = parse_input_2(path)
part_1 = solve_part_1(input)
part_2 = solve_part_2(input2)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"