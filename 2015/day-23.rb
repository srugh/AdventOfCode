def parse_input(path)
  lines =[]
  File.foreach(path) do |line|
    temp = line.split
    temp[1] = temp[1].delete(",")
    if temp.size == 3
      temp[2] = temp[2].delete("+")
      temp[2] = temp[2].to_i
    end
    if temp[1] != "a" && temp[1] != "b"
      temp[1] = temp[1].to_i
    end
    lines.push(temp)
  end
  lines
end


def solve_part_1(input)
  registers = Hash.new
  registers["a"], registers["b"] = 1, 0
  offset = 0
# hlf r sets register r to half its current value, then continues with the next instruction.
# tpl r sets register r to triple its current value, then continues with the next instruction.
# inc r increments register r, adding 1 to it, then continues with the next instruction.
# jmp offset is a jump; it continues with the instruction offset away relative to itself.
# jie r, offset is like jmp, but only jumps if register r is even ("jump if even").
# jio r, offset is like jmp, but only jumps if register r is 1 ("jump if one", not odd).
  while offset < input.size
    inst, arg_1, arg_2 = input[offset]
    p offset
    p input[offset]
    case inst
    when "hlf"
      registers[arg_1] /= 2
      offset += 1
    when "tpl"
      registers[arg_1] *= 3
      offset += 1
    when "inc" 
      registers[arg_1] += 1
      offset += 1
    when "jmp"
      offset += arg_1
    when "jie"
      offset = registers[arg_1] % 2 == 0 ? offset + arg_2 : offset + 1
    when "jio"
      offset = registers[arg_1] == 1 ? offset + arg_2 : offset + 1
    end
  end
  p registers
end

path = "Inputs/day-23.txt"
input = parse_input(path)
part_1 = solve_part_1(input)
puts "part_1: #{part_1}"










