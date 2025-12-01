require 'set'
def parse_input(input)
    test_cases = []
    app = []

    parts = File.read(input).split("\n\n\n\n")

    part_1 = parts[0].split("\n\n")
    part_2 = parts[1].split("\n")

    part_1.each do |tuple|
        registers = tuple.scan(/\[(\d), (\d), (\d), (\d)/)
        instruction = tuple.scan(/^(\d+) (\d) (\d) (\d)/)

        test_cases.push([registers[0].map(&:to_i), registers[1].map(&:to_i), instruction[0].map(&:to_i)])
    end

    part_2.each do |line|
        instruction = line.chomp.split(" ")
        app.push(instruction.map(&:to_i))
    end
    
    [test_cases, app]
end

def calc_part_1(test_cases, op_codes)
    samples_correct_op_code = Hash.new
    op_code_to_sample = Hash.new
    samples_with_3 = 0

    test_cases.each_with_index do |test_case, idx|
        registers_before, registers_after, instruction = test_case
        correct_results = 0
        op_codes.each do |op_code|
            result = execute_op(registers_before.dup, instruction, op_code)
            if result == registers_after
                correct_results += 1 
                samples_correct_op_code[idx] == nil ? samples_correct_op_code[idx] = [op_code] : samples_correct_op_code[idx].push(op_code)
                op_code_to_sample[op_code] == nil ? op_code_to_sample[op_code] = [idx] : op_code_to_sample[op_code].push(idx)
            end
        end
        if correct_results >= 3
            samples_with_3 += 1
        end
    end

    samples_with_3
end

def calc_part_2(instructions)
    registers = Array.new(4, 0)

    instructions.each_with_index do |instruction, idx|
        registers = execute_num_op(registers, instruction)
    end

    registers[0]
end

def execute_num_op(registers, instruction)
    op_code, a, b, c = instruction

    case op_code
    when 11
        registers[c] = registers[a] + registers[b]
    when 5
        registers[c] = registers[a] + b 
    when 1
        registers[c] = registers[a] * registers[b]
    when 8
        registers[c] = registers[a] * b 
    when 4
        registers[c] = registers[a] & registers[b]
    when 12
        registers[c] = registers[a] & b
    when 13
        registers[c] = registers[a] | registers[b]
    when 9
        registers[c] = registers[a] | b
    when 10
        registers[c] = registers[a]
    when 6
        registers[c] = a
    when 7
        a > registers[b] ? registers[c] = 1 : registers[c] = 0
    when 2
        registers[a] > b ? registers[c] = 1 : registers[c] = 0
    when 3
        registers[a] > registers[b] ? registers[c] = 1 : registers[c] = 0
    when 14
        a == registers[b] ? registers[c] = 1 : registers[c] = 0
    when 0
        registers[a] == b ? registers[c] = 1 : registers[c] = 0
    when 15
        registers[a] == registers[b] ? registers[c] = 1 : registers[c] = 0
    else
        puts "broken: #{op_code}"
    end

    registers
end

def execute_op(registers, instruction, op_code)
    op, a, b, c = instruction

    case op_code
    when "addr"
        registers[c] = registers[a] + registers[b]
    when "addi"
        registers[c] = registers[a] + b 
    when "mulr"
        registers[c] = registers[a] * registers[b]
    when "muli"
        registers[c] = registers[a] * b 
    when "banr"
        registers[c] = registers[a] & registers[b]
    when "bani"
        registers[c] = registers[a] & b
    when "borr"
        registers[c] = registers[a] | registers[b]
    when "bori"
        registers[c] = registers[a] | b
    when "setr"
        registers[c] = registers[a]
    when "seti"
        registers[c] = a
    when "gtir"
        a > registers[b] ? registers[c] = 1 : registers[c] = 0
    when "gtri"
        registers[a] > b ? registers[c] = 1 : registers[c] = 0
    when "gtrr"
        registers[a] > registers[b] ? registers[c] = 1 : registers[c] = 0
    when "eqir"
        a == registers[b] ? registers[c] = 1 : registers[c] = 0
    when "eqri"
        registers[a] == b ? registers[c] = 1 : registers[c] = 0
    when "eqrr"
        registers[a] == registers[b] ? registers[c] = 1 : registers[c] = 0
    else
        puts "broken: #{op_code}"
    end

    registers
end

input = "Inputs/day-16.txt"
op_codes = ["addr", "addi", "mulr", "muli", "banr", "bani", "borr", "bori", "setr", "seti", "gtir", "gtri", "gtrr", "eqir", "eqri", "eqrr"]


test_cases, app = parse_input(input)

solution_1 = calc_part_1(test_cases, op_codes)
solution_2 = calc_part_2(app)

puts "part_1: #{solution_1} / #{test_cases.size}"
puts "part_2: #{solution_2}"