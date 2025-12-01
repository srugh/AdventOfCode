def parse_input(path)
   File.read(path).split(/\n/)
end

def solve_part_1(input)
  char_val = Hash.new
  value = 1

  ('a'..'z').each do |letter|
    char_val[letter] = value
    value += 1
  end

  # Add uppercase letters A-Z with values 27-52
  ('A'..'Z').each do |letter|
    char_val[letter] = value
    value += 1
  end
 
  total = 0
  input.each do |s|
    shared = (s[0, s.size/2].chars & s[s.size/2, s.size-1].chars)
    val = char_val[shared[0]]
    total = total + val
  end

  total
end

def solve_part_2(input)
  char_val = Hash.new
  value = 1

  ('a'..'z').each do |letter|
    char_val[letter] = value
    value += 1
  end

  # Add uppercase letters A-Z with values 27-52
  ('A'..'Z').each do |letter|
    char_val[letter] = value
    value += 1
  end

  total = 0
  while input.size > 0 do
    group = []
    group.push(input.shift)
    group.push(input.shift)
    group.push(input.shift)

    badge = group.map(&:chars).inject(:&)
    val = char_val[badge[0]]
    total = total + val
  end
  total
end


path = "Inputs/day-03.txt"
input = parse_input(path)
part_1 = solve_part_1(input)
part_2 = solve_part_2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"