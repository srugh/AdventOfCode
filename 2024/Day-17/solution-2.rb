require 'set'

def parse_input(input_file)
    registers = Hash.new
    instructions = []
    parts = File.read(input_file).split("\n\n")

    parts[0].split("\n").each do |line|
        temp = line.chomp.split(" ")
        registers[temp[1].chars[0].strip] = temp[2].strip.to_i
    end

    sub_parts = parts[1].split(" ")
    sub_parts[1].split(",").each do |char|
        instructions.push(char.to_i)
    end

    [registers, instructions]
end 

def get_operand_value(opcode, operand, registers)
    if [1,3,4].include?(opcode)
       
        return operand
    else
        if [0,1,2,3].include?(operand)
            return operand
        elsif operand == 4
            return registers["A"]
        elsif operand == 5
            return registers["B"]
        elsif operand == 6
            return registers["C"]
        else
            puts "SHOULD NOT BE HERE!"
        end
    end
end

def process_opcode(opcode, operand, instruction_pointer, registers)
    out = ""

    case opcode
    when 0
        
        value = get_operand_value(opcode, operand, registers)
        
        num = registers["A"]
        if $power_cache.key?(value)
            $power_hits += 1  # Increment memo hit counter
          else
            $power_cache[value] = 2 ** value
          end
          den = $power_cache[value]
          key = [num, den]
          result = if $division_cache.key?(key)
                      $division_hits += 1
                      $division_cache[key]
                   else
                      $division_cache[key] = num.div(den)
                   end

        registers["A"] = result

        
    when 1

        value = get_operand_value(opcode, operand, registers)

        left = registers["B"]
        right = value
        result = left ^ right

        registers["B"] = result
    
    when 2
 
        value = get_operand_value(opcode, operand, registers)

        num = value
        mod = 8
        mask = 0b111  # Binary mask for % 8 (3 least significant bits)
        key = value & mask
        if $mod_cache.key?(key)
            $mod_hits += 1
          else
            $mod_cache[key] = key
          end
          result = $mod_cache[key]
          

        registers["B"] = result

    when 3

        if registers["A"] != 0

            value = get_operand_value(opcode, operand, registers)

            instruction_pointer = value
        end

    when 4

        registers["B"] = registers["B"] ^ registers["C"]
    
    when 5

        value = get_operand_value(opcode, operand, registers)

        num = value
        mod = 8
        mask = 0b111  # Binary mask for % 8 (3 least significant bits)
        key = value & mask
        if $mod_cache.key?(key)
            $mod_hits += 1
          else
            $mod_cache[key] = key
          end
          result = $mod_cache[key]
          

        out = result

    when 6

        value = get_operand_value(opcode, operand, registers)
            
        num = registers["A"]
        if $power_cache.key?(value)
            $power_hits += 1  # Increment memo hit counter
          else
            $power_cache[value] = 2 ** value
          end
          den = $power_cache[value]
          
          key = [num, den]
          result = if $division_cache.key?(key)
                      $division_hits += 1
                      $division_cache[key]
                   else
                      $division_cache[key] = num.div(den)
                   end

        registers["B"] = result

    when 7

        value = get_operand_value(opcode, operand, registers)
            
            num = registers["A"]
            if $power_cache.key?(value)
                $power_hits += 1  # Increment memo hit counter
              else
                $power_cache[value] = 2 ** value
              end
              den = $power_cache[value]
              
              key = [num, den]
              result = if $division_cache.key?(key)
                          $division_hits += 1
                          $division_cache[key]
                       else
                          $division_cache[key] = num.div(den)
                       end

            registers["C"] = result

    end
    [registers, instruction_pointer, out]
end

def calc_reg_a_value(registers, instructions)
    initial_a = 0
    out = ""
#243_439_201
#6_823_413
    loop do 
        puts "#{initial_a} \t #{$power_hits} \t #{$mod_hits}"
        registers["A"] = initial_a
        out = run_instructions(registers, instructions)
        puts out
        break unless out != instructions.join(",")
        initial_a += 1
    end

    initial_a
end

def run_instructions(registers, instructions)
    instruction_pointer = 0
    opcode = 0
    operand = 0

    total_out = []
    out_count = 0

    while instruction_pointer < instructions.size do
        opcode = instructions[instruction_pointer]
        operand = instructions[instruction_pointer+1]
        
        registers, pointer, out = process_opcode(opcode, operand, instruction_pointer, registers)
        
        if pointer == instruction_pointer
            instruction_pointer += 2
        else
            instruction_pointer = pointer
        end

        if out != ""
            total_out.push(out)
            return "" unless total_out[out_count] == instructions[out_count]
            out_count += 1
        end
        
    end

    total_out.join(",")

end

def valid_start?(register_a, expected_mod)
    # Simulate first output % 8
    result = register_a % 8  # Assuming A contributes directly
    result == expected_mod
  end
  
  def calc_reg_a_value_with_early_pruning(registers, instructions)
    # Find expected first output
    first_output_opcode_index = instructions.index(5)
    expected_mod = instructions[first_output_opcode_index + 1] % 8
  
    initial_a = 243_439_201
  
    loop do
       puts "#{initial_a} \t #{$power_hits} \t #{$mod_hits} \t #{$division_hits}"
      # Skip invalid starting points
      unless valid_start?(initial_a, expected_mod)
        initial_a += 1
        next
      end
  
      registers["A"] = initial_a
      out = run_instructions(registers, instructions)
  
      if out == instructions.join(",")
        return initial_a  # Found valid A
      end
  
      initial_a += 1
    end
  end
  def run_a(program, registers, a)
    reg = registers.dup
    reg["A"] = a.to_i  # Set the initial value of register A
    run_instructions(reg, program)
  end
  
  def calc_reg_a_value_with_search_quine(registers, instructions)
    search_quine(instructions, registers)
  end

  def search_quine(program, registers)
    queue = (0..7).to_a  # Start with all 3-bit possibilities
  
    while queue.any?
      possible_a = queue.shift
  
      # Check if the output matches the expected reverse pattern
      if possible_a.bit_length / 3 + 1 == program.size
        return possible_a
      end
  
      # Generate next candidates
      (0..7).each do |i|
        a = (possible_a << 3) + i  # Append 3 bits
        partial_output = run_a(program, registers, a)
  
        # Check if this candidate is valid
        if partial_output == program[-((a.bit_length / 3) + 1)..]
          queue << a
        end
      end
    end
  end
  

input_file = "Inputs/sample-b.txt"
input_file = "Inputs/input.txt"

registers = Hash.new
instructions = []
output = ""

# Memoization Hashes
$operand_cache = {}
$power_cache = {}
$mod_cache = {}
$division_cache = {}
$division_hits = 0
$power_hits = 0
$mod_hits = 0

registers, instructions = parse_input(input_file)

register_a = calc_reg_a_value_with_search_quine(registers,instructions)

puts "Value for register a: #{register_a}"

puts search_quine(registers, instructions)