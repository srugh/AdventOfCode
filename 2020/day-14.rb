def parse_inputs(path)
  inputs = []
  File.readlines(path, chomp:true).each do |line|
    inputs.push(line.split(" = "))
  end
  inputs
end

def solve_part_1(inputs)
  mem_hash = Hash.new
  mask = ""

  inputs.each do |input|
    if input[0] == "mask"
      mask = input[1]
      next
    else
      mem = input[0]
      int = input[1].to_i
      bin = int.to_s(2).rjust(36, '0')
      
      mem_hash[mem] = compute_masked_result(mask, bin)
    end
  end
  total = 0
  mem_hash.each do |key, val|
    total += val.to_i(2)
  end
  total
end

def compute_masked_result(mask, bin)
  masked = '0'.rjust(36, '0')

  mask.size.times do |i|
    if mask[i] == "0"
      masked[i] = "0"
    elsif mask[i] == "1"
      masked[i] = "1"
    else
      masked[i] = bin[i]
    end
  end
  masked
end

def solve_part_2(inputs)
  mem_hash = Hash.new
  mask = ""

  inputs.each do |input|
    if input[0] == "mask"
      mask = input[1]
      next
    else
      mem = input[0].scan(/mem\[(\d+)/).flatten[0].to_i.to_s(2).rjust(36, '0')
  
      int = input[1].to_i

      mem_slots = compute_masked_mem_slots(mask, mem)
      
      mem_slots.each do |mem_slot|
        mem_hash[mem_slot] = int
      end
    end
  end
  total = 0
 
  mem_hash.each do |key, val|
    total += val
    puts val
  end
  total
end
  
def compute_masked_mem_slots(mask, mem)
  masked = '0'.rjust(36, '0')
  mem_slots = []
  floating_spots = []

  mask.size.times do |i|
    if mask[i] == "0"
      masked[i] = mem[i]
    elsif mask[i] == "1"
      masked[i] = "1"
    else
     masked[i] = "X"
     floating_spots.push(i)
    end
  end

  tot_float_permutations = 2**floating_spots.size
  binary_perms = generate_binary_permutations(floating_spots.size)
  
  tot_float_permutations.times do |i|
    m = masked.dup
    floating_spots.each_with_index do |spot, j|
      m[spot] = binary_perms[i][j]
    end
    mem_slots.push(m)
  end

  mem_slots
end

def generate_binary_permutations(n)
  permutations = []

  (0...(2**n)).each do |i|
    binary_string = i.to_s(2)
    permutations << binary_string.rjust(n, '0')
  end
  permutations
end

path = "Inputs/day-14.txt"

input = parse_inputs(path)

part_1 = solve_part_1(input)
part_2 = solve_part_2(input)

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"