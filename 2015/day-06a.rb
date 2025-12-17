# frozen_string_literal: true

def read_data(file_path)
  File.readlines(file_path, chomp: true).map do |line|
    # Match the instruction and coordinates
    next unless line.match(/(turn off|turn on|toggle) (\d+),(\d+) through (\d+),(\d+)/)

    action = Regexp.last_match(1)
    x1 = Regexp.last_match(2).to_i
    y1 = Regexp.last_match(3).to_i
    x2 = Regexp.last_match(4).to_i
    y2 = Regexp.last_match(5).to_i
    [action, [x1, y1], [x2, y2]]
  end
end

def process_instructions(instructions, grid, actions)
  instructions.each do |instruction|
    operation = actions[instruction[0]]
    (instruction[1][0]..instruction[2][0]).each do |x|
      (instruction[1][1]..instruction[2][1]).each do |y|
        grid[x][y] = operation.call(grid[x][y])
      end
    end
  end
end

input_file = 'Inputs/day-06.txt'
grid = Array.new(1000) { Array.new(1000, 0) }

actions = {
  'toggle' => ->(value) { value == 1 ? 0 : 1 },
  'turn on' => ->(_value) { 1 },
  'turn off' => ->(_value) { 0 }
}

instructions = read_data(input_file)

process_instructions(instructions, grid, actions)

puts "Total lights turned on: #{grid.flatten.count(1)}"
