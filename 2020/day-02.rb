def parse_input(file)
    inputs = []
    File.readlines(file, chomp:true).each do |line|
        parts = line.split
        range = parts[0].split("-")
        inputs.push([range[0], range[1], parts[1][0], parts[2]])
    end

    inputs
end

def solve_part_1(inputs)
  valid_passwords = 0

  inputs.each do |input|
    low = input[0].to_i
    high = input[1].to_i
    letter = input[2]
    pw = input[3]

    occurances = pw.count(letter)

    if occurances >= low && occurances <= high
      valid_passwords += 1
    end
  end

  valid_passwords
end

def solve_part_2(inputs)
  valid_passwords = 0

  inputs.each do |input|
    low = input[0].to_i
    high = input[1].to_i
    letter = input[2]
    pw = input[3]

    if (pw[low-1] == letter) ^ (pw[high-1] == letter)
      valid_passwords += 1
    end
  end

  valid_passwords
end


file = "Inputs/day-02.txt"

inputs = parse_input(file)

part_1 = solve_part_1(inputs)
part_2 = solve_part_2(inputs)

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"