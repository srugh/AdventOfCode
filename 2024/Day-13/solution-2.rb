
def parse_instructions(file_path)
    # Read the file and split it into blocks of 3 lines
    instructions = File.read(file_path).split("\n\n").map do |block|
      lines = block.split("\n")
      {
        a: parse_button(lines[0]),
        b: parse_button(lines[1]),
        prize: parse_prize(lines[2])
      }
    end
  
    instructions
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
      x: match[1].to_i + 10000000000000,
      y: match[2].to_i + 10000000000000
    }
end

def calc_winning_strategy(instructions)
    total_tokens = 0
        
    instructions.each_with_index do |instruction, idx|

   
        winnable, tokens = play_game(instruction)
        puts "#{idx+1}: winnable: #{winnable} tokens: #{tokens}"
        if winnable 
            total_tokens += tokens
        end 
        
    end
    total_tokens
end


def determinant(matrix)
    matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
end

def play_game(instruction)
    a_x, a_y = instruction[:a][:x], instruction[:a][:y]
    b_x, b_y = instruction[:b][:x], instruction[:b][:y]
    p_x, p_y = instruction[:prize][:x], instruction[:prize][:y]
  
    d = [[a_x, b_x], [a_y, b_y]]
    d_a = [[p_x, b_x], [p_y, b_y]]
    d_b = [[a_x, p_x], [a_y, p_y]]
  
    det_d = determinant(d)
    return [false, 0] if det_d == 0

    det_d_a = determinant(d_a)
    det_d_b = determinant(d_b)
  
    a = det_d_a.to_f / det_d
    b = det_d_b.to_f / det_d
  
    # Check if both a and b are non-negative integers
    if a >= 0 && b >= 0 && a % 1 == 0 && b % 1 == 0
      tokens = (3 * a + b).to_i
      return [true, tokens]
    end
end


#input_file = "Inputs/sample.txt"
input_file = "Inputs/input1.txt"

instructions = []
instructions = parse_instructions(input_file)

total_tokens = calc_winning_strategy(instructions)

puts "Total tokens needed: #{total_tokens}"