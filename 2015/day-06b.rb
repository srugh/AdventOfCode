def read_data(file_path)
    File.readlines(file_path, chomp: true).map do |line|
        # Match the instruction and coordinates
        if line.match(/(turn off|turn on|toggle) (\d+),(\d+) through (\d+),(\d+)/)
            action = $1
            x1, y1 = $2.to_i, $3.to_i
            x2, y2 = $4.to_i, $5.to_i
            [action, [x1, y1], [x2, y2]]
        end
    end
end

def process_instructions( instructions, grid, actions )
    instructions.each do |instruction| 
        operation = actions[instruction[0]]
        (instruction[1][0]..instruction[2][0]).each do |x|
            (instruction[1][1]..instruction[2][1]).each do |y|
                grid[x][y] = operation.call(grid[x][y])
            end
        end
    end
    
end


input_file = "Inputs/day-06.txt"
grid = Array.new(1000) { Array.new(1000, 0) }

actions = {
  "toggle"   => ->(value) { value + 2 },
  "turn on"  => ->(value) { value + 1 },
  "turn off" => ->(value) { value - 1 < 0 ? 0 : value - 1}
}

instructions = read_data(input_file)

process_instructions(instructions, grid, actions)

puts "Total light brightness turned on: #{grid.flatten.sum}"