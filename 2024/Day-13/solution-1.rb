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
    x: match[1].to_i,
    y: match[2].to_i
  }
end

def calc_winning_strategy(instructions)
  total_tokens = 0
  instructions.each_with_index do |instruction, _idx|
    winnable, tokens = play_game(instruction)
    # puts "#{idx+1}: winnable: #{winnable} tokens: #{tokens[0]}"
    total_tokens += tokens[0] if winnable
    # break
  end
  total_tokens
end

def play_game(instruction)
  count = 100
  a_x = instruction[:a][:x]
  a_y = instruction[:a][:y]
  b_x = instruction[:b][:x]
  b_y = instruction[:b][:y]
  prize_x = instruction[:prize][:x]
  prize_y = instruction[:prize][:y]

  solutions = []

  (1..(count - 1)).each do |a|
    (1..(count - 1)).each do |b|
      x_tot = (a * a_x) + (b * b_x)
      y_tot = (a * a_y) + (b * b_y)
      if is_winner?(x_tot, y_tot, prize_x, prize_y) == true
        solutions.push([calc_tokens(a, b)])
        # puts "total: #{calc_tokens(a,b)} a: #{a} b: #{b}"
      end
    end
  end

  return [false, solutions] if solutions.empty?

  [true, solutions.min]
end

def is_winner?(x_tot, y_tot, prize_x, prize_y)
  x_tot == prize_x && y_tot == prize_y
end

def calc_tokens(button_a_presses, button_b_presses)
  (3 * button_a_presses) + button_b_presses
end
input_file = 'Inputs/input1.txt'
instructions = parse_instructions(input_file)

total_tokens = calc_winning_strategy(instructions)

puts "Total tokens needed: #{total_tokens}"
