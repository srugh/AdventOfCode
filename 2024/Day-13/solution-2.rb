# frozen_string_literal: true

def parse_instructions(file_path)
  # Read the file and split it into blocks of 3 lines
  File.read(file_path).split("\n\n").map do |block|
    lines = block.split("\n")
    {
      a: parse_button(lines[0]),
      b: parse_button(lines[1]),
      prize: parse_prize(lines[2])
    }
  end
end

def parse_button(line)
  match = line.match(/Button [AB]: X\+(\d+), Y\+(\d+)/)
  {
    x: match[1].to_i,
    y: match[2].to_i
  }
end

def parse_prize(line)
  match = line.match(/Prize: X=(\d+), Y=(\d+)/)
  {
    x: match[1].to_i + 10_000_000_000_000,
    y: match[2].to_i + 10_000_000_000_000
  }
end

def calc_winning_strategy(instructions)
  total_tokens = 0

  instructions.each_with_index do |instruction, idx|
    winnable, tokens = play_game(instruction)
    puts "#{idx + 1}: winnable: #{winnable} tokens: #{tokens}"
    total_tokens += tokens if winnable
  end
  total_tokens
end

def determinant(matrix)
  (matrix[0][0] * matrix[1][1]) - (matrix[0][1] * matrix[1][0])
end

def play_game(instruction)
  a_x = instruction[:a][:x]
  a_y = instruction[:a][:y]
  b_x = instruction[:b][:x]
  b_y = instruction[:b][:y]
  p_x = instruction[:prize][:x]
  p_y = instruction[:prize][:y]

  d = [[a_x, b_x], [a_y, b_y]]
  d_a = [[p_x, b_x], [p_y, b_y]]
  d_b = [[a_x, p_x], [a_y, p_y]]

  det_d = determinant(d)
  return [false, 0] if det_d.zero?

  det_d_a = determinant(d_a)
  det_d_b = determinant(d_b)

  a = det_d_a.to_f / det_d
  b = det_d_b.to_f / det_d

  # Check if both a and b are non-negative integers
  return unless a >= 0 && b >= 0 && (a % 1).zero? && (b % 1).zero?

  tokens = ((3 * a) + b).to_i
  [true, tokens]
end

# input_file = "Inputs/sample.txt"
input_file = 'Inputs/input1.txt'
instructions = parse_instructions(input_file)

total_tokens = calc_winning_strategy(instructions)

puts "Total tokens needed: #{total_tokens}"
