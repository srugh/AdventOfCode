def parse_input(path)
  File.read(path).split(/\n/)
end

def solve_part_1(input)

  code_total   = 0
  memory_total = 0

  input.each do |line|
    code_total   += line.length
    memory_total += eval(line).length
  end

  code_total - memory_total
end

def solve_part_2(lines)
  total_orig    = 0
  total_encoded = 0

  lines.each do |s|
    s = s.chomp
    orig_len = s.length
    encoded_len = orig_len + s.count('"') + s.count('\\') + 2

    total_orig    += orig_len
    total_encoded += encoded_len
  end

  total_encoded - total_orig
end

path = "Inputs/day-08.txt"
input = parse_input(path)
part_1 = solve_part_1(input)

part_2 = solve_part_2(input)
puts "part_1: #{part_1}"
puts "part_2: #{part_2}"