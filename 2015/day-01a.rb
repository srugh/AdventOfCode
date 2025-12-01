

def read_data(input_file)
    instructions = File.read(input_file)

    instructions
end

def process_instructions(instructions)
    floor = 0
    instructions.each_char do |instruction|
        if instruction == '('
            floor += 1
        elsif instruction ==')'
            floor -= 1
        end
    end
    floor
end

input_file = "Inputs/day-01.txt"

instructions = read_data(input_file)

puts "Santa ends on floor: #{process_instructions(instructions)}"

