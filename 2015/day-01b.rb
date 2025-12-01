

def read_data(input_file)
    instructions = File.read(input_file)
    instructions
end

def process_instructions(instructions)
    floor = 0
    instruction_count = 1
    found_basement = false

    instructions.each_char do |instruction|
        if instruction == '('
            floor += 1
        elsif instruction ==')'
            floor -= 1
        end

        if floor == -1 && !found_basement 
            found_basement = true
        elsif !found_basement
            instruction_count += 1
        end
    end
    [floor, instruction_count]
end

input_file = "Inputs/day-01.txt"

instructions = read_data(input_file)

final_floor, first_basement_access = process_instructions(instructions)
puts "Santa ends on floor: #{final_floor}"
puts "Santa first reached basement on step: #{first_basement_access}"