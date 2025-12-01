def parse_input(path)
  File.read(path).split(/\n/).map{|c| c.split}
end

def solve_part_1(instructions)
  storage = Hash.new
  storage["w"] = 0
  storage["x"] = 0
  storage["y"] = 0
  storage["z"] = 0

  input = 99999999999999

  while input >= 11111111111111
    puts input if input % 100000 == 0
    input_chars = input.to_s.chars
    if input_chars.count("0") > 0
      input -= 1
      next
    end
    storage = Hash.new
    storage["w"] = 0
    storage["x"] = 0
    storage["y"] = 0
    storage["z"] = 0
    instructions.each do |ins|
      action, left, right = ins
      case action
      when "inp"
        storage[left] = input_chars.shift[0].to_i
      when "add"
        storage[left] += storage.key?(right) ? storage[right] : right.to_i
      when "mul"
        storage[left] *= storage.key?(right) ? storage[right] : right.to_i
      when "div"
        right = storage.key?(right) ? storage[right] : right.to_i 
        return "divide by 0" if right == 0
        storage[left] /= right
      when "mod"
        right = storage.key?(right) ? storage[right] : right.to_i
        return "mod contains a 0" if storage[left] < 0 || right <= 0
        storage[left] %= right
      when "eql"
        right = right = storage.key?(right) ? storage[right] : right.to_i
        storage[left] = storage[left] == right ? 1 : 0
      end
    end
    return storage[z] if storage["z"] == 0
    input -= 1
  end
  p storage
end

def solve_part_2(input)
  
end


path = "Inputs/day-24.txt"
input = parse_input(path)
part_1 = solve_part_1(input)
part_2 = solve_part_2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"