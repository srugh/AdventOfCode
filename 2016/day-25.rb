def parse_input(path)
  File.read(path).split(/\n/).map {|s| s.split}
end

def solve_part_1(instructions)
  registers = Hash.new
  registers["a"], registers["b"], registers["c"], registers["d"] = 0, 0, 0, 0
  offset = 0
  found = false
  attempt = 0
  quit =0
  puts "offset: #{offset}, a: #{registers["a"]}, b: #{registers["b"]}, c: #{registers["c"]}, d: #{registers["d"]}"
  transmit = ""
  reset = false
  while !found
    if reset 
      transmit = ""
      attempt += 1
      registers = Hash.new
      registers["a"], registers["b"], registers["c"], registers["d"] = attempt, 0, 0, 0
      instructions = parse_input("Inputs/day-25.txt")
      offset = 0
      reset = false
      puts registers["a"] if attempt % 1000 == 0
    end
    quit += 1
   
    #p registers
    #p instructions[offset]
    command, arg_1, arg_2 = instructions[offset]
    #puts "command: #{command}, a1: #{arg_1}, a2: #{arg_2}"

    case command
    when "cpy"
      arg_1 = ["a", "b", "c", "d"].include?(arg_1) ? registers[arg_1] : arg_1.to_i
      registers[arg_2] = arg_1 if ["a", "b", "c", "d"].include?(arg_2) 
      offset += 1
    when "inc"
      registers[arg_1] += 1
      offset += 1
    when "dec"
      registers[arg_1] -= 1
      offset += 1
    when "jnz"
      arg_1 = ["a", "b", "c", "d"].include?(arg_1) ? registers[arg_1] : arg_1.to_i
      arg_2 = ["a", "b", "c", "d"].include?(arg_2) ? registers[arg_2] : arg_2.to_i
      offset += arg_1 != 0 ? arg_2 : 1
    when "out"
      arg_1 = ["a", "b", "c", "d"].include?(arg_1) ? registers[arg_1] : arg_1.to_i
      transmit += arg_1.to_s
    when "tgl"
      arg_1 = ["a", "b", "c", "d"].include?(arg_1) ? registers[arg_1] : arg_1.to_i
      if offset+arg_1 >= instructions.size
        offset += 1
        next
      end
      temp = instructions[offset+arg_1] 

      case temp[0]
      when "inc"
        instructions[offset+arg_1][0] = "dec"
      when "dec"
        instructions[offset+arg_1][0] = "inc"
      when "cpy"
        instructions[offset+arg_1][0] = "jnz"
      when "jnz"
        instructions[offset+arg_1][0] = "cpy"
      when "tgl"
        instructions[offset+arg_1][0] = "inc"
      end
      offset += 1
    end
    #puts "offset: #{offset}, a: #{registers["a"]}, b: #{registers["b"]}, c: #{registers["c"]}, d: #{registers["d"]}"
    #puts
    if transmit.length >= 2 && !transmit.match?(/^(01)+$/)
      reset = true
      #puts transmit
     
    elsif transmit.length >= 20 && transmit.match?(/^(01)+$/)
      puts "found it!"
      p registers["a"]
      found = true
      break
    end
  end
  registers["a"]
end

path = "Inputs/day-25.txt"
input = parse_input(path)
p solve_part_1(input)