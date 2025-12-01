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
    #The adv instruction (opcode 0) performs division. The numerator is the value in the A register. 
    #The denominator is found by raising 2 to the power of the instruction's combo operand. 
    #(So, an operand of 2 would divide A by 4 (2^2); an operand of 5 would divide A by 2^B.) 
    #The result of the division operation is truncated to an integer and then written to the A register.
        
        puts "opcode: #{opcode} \t operand: #{operand} \t register[A]: #{registers["A"]}"
        value = get_operand_value(opcode, operand, registers)
        
        num = registers["A"]
        den = 2 ** value
        puts "num / den:  #{num} / #{den}"
        result = (num / den).to_i

        registers["A"] = result

        
    when 1
    #The bxl instruction (opcode 1) calculates the bitwise XOR of register B 
    #and the instruction's literal operand, then stores the result in register B. 
        value = get_operand_value(opcode, operand, registers)

        left = registers["B"]
        right = value
        result = left ^ right

        registers["B"] = result
    
    when 2
    #The bst instruction (opcode 2) calculates the value of its combo operand modulo 8 
    #(thereby keeping only its lowest 3 bits), then writes that value to the B register.
        value = get_operand_value(opcode, operand, registers)

        num = value
        mod = 8
        result = value % mod

        registers["B"] = result

    when 3
    #The jnz instruction (opcode 3) does nothing if the A register is 0. 
    #if the A register is not zero, it jumps by setting the instruction pointer 
    #to the value of its literal operand; if this instruction jumps, 
    #the instruction pointer is not increased by 2 after this instruction.
        if registers["A"] != 0

            value = get_operand_value(opcode, operand, registers)

            instruction_pointer = value
        end

    when 4
    #The bxc instruction (opcode 4) calculates the bitwise XOR of register B and register C, 
    #then stores the result in register B. (For legacy reasons, this instruction reads an operand 
    #but ignores it.)
        registers["B"] = registers["B"] ^ registers["C"]
    
    when 5
    #The out instruction (opcode 5) calculates the value of its combo operand modulo 8, 
    #then outputs that value. (If a program outputs multiple values, they are separated by commas.)
        value = get_operand_value(opcode, operand, registers)

        num = value
        mod = 8
        result = value % mod

        out = result

    when 6
    #The bdv instruction (opcode 6) works exactly like the adv instruction 
    #except that the result is stored in the B register. 
    #(The numerator is still read from the A register.)
        value = get_operand_value(opcode, operand, registers)
            
        num = registers["A"]
        den = 2 ** value
        result = (num / den).to_i

        registers["B"] = result

    when 7
    #The cdv instruction (opcode 7) works exactly like the adv instruction 
    #except that the result is stored in the C register. 
    #(The numerator is still read from the A register.)
        value = get_operand_value(opcode, operand, registers)
            
            num = registers["A"]
            den = 2 ** value
            result = (num / den).to_i

            registers["C"] = result

    end
    [registers, instruction_pointer, out]
end

def run_instructions(registers, instructions)
    instruction_pointer = 0
    opcode = 0
    operand = 0

    total_out = []

    while instruction_pointer < instructions.size do
        opcode = instructions[instruction_pointer]
        operand = instructions[instruction_pointer+1]
        
        registers, pointer, out = process_opcode(opcode, operand, instruction_pointer, registers)
        
        if pointer == instruction_pointer
            instruction_pointer += 2
        else
            instruction_pointer = pointer
        end

        total_out.push(out) unless out == ""
        
    end

    total_out.join(",")

end



input_file = "Inputs/sample.txt"
input_file = "Inputs/input.txt"

registers = Hash.new
instructions = []
output = ""

registers, instructions = parse_input(input_file)

output = run_instructions(registers,instructions)

puts "Output of instructions: #{output}"