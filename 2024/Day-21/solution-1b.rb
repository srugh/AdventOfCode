# Numeric keypad: mapping character to (row, col)
NUMERIC_KEYPAD = {
  '7' => [1, 1],
  '8' => [1, 2],
  '9' => [1, 3],
  '4' => [2, 1],
  '5' => [2, 2],
  '6' => [2, 3],
  '1' => [3, 1],
  '2' => [3, 2],
  '3' => [3, 3],
  '0' => [4, 2],
  'A' => [4, 3]
}

# Directional keypad: mapping button to (row, col)
DIRECTIONAL_KEYPAD = {
  '^' => [1, 2],
  'A' => [1, 3],
  '<' => [2, 1],
  'v' => [2, 2],
  '>' => [2, 3]
}

# Function to get character at a numeric keypad position
def get_char_at(pos, numeric_keypad)
  numeric_keypad.each do |key, p|
    return key if p == pos
  end
  nil
end

# Function to get position from character on numeric keypad
def get_pos(char, numeric_keypad)
  numeric_keypad[char]
end

# Function to extract the numeric part of the code
def extract_numeric_part(code)
  match = code.match(/\d+/)
  match ? match[0].to_i : 0
end


def bfs_min_presses(code, numeric_keypad, directional_keypad)
    require 'set'
    
    # Define possible directional moves with their delta changes
    DIRECTIONS = {
      '<' => [0, -1],
      '>' => [0, 1],
      '^' => [-1, 0],
      'v' => [1, 0]
    }
    
    # Initialize BFS
    initial_pos = numeric_keypad['A'] # Starting at 'A' ([4,3])
    target_sequence = code.chars
    queue = []
    queue << [initial_pos, 0, 0] # [current_pos, current_index, button_presses]
    visited = Set.new
    visited.add([initial_pos, 0])
    
    while !queue.empty?
      current_state = queue.shift
      current_pos, current_index, presses = current_state
      
      # If all characters have been pressed
      if current_index == target_sequence.size
        return presses
      end
      
      # Next desired character to press
      desired_char = target_sequence[current_index]
      desired_pos = numeric_keypad[desired_char]
      
      # Action 1: Press 'A' if at desired position
      if current_pos == desired_pos
        new_index = current_index + 1
        new_presses = presses + 1 # Press 'A'
        new_state = [current_pos, new_index]
        
        unless visited.include?(new_state)
          queue << [current_pos, new_index, new_presses]
          visited.add(new_state)
        end
      end
      
      # Action 2: Press directional buttons ('<', '>', '^', 'v')
      DIRECTIONS.each do |dir, delta|
        new_r = current_pos[0] + delta[0]
        new_c = current_pos[1] + delta[1]
        new_pos = [new_r, new_c]
        
        # Check if new_pos is within keypad bounds
        if new_r >= 1 && new_r <= 4 && new_c >=1 && new_c <=3
          # Check if new_pos is a valid button (not a gap)
          new_char = get_char_at(new_pos, numeric_keypad)
          next if new_char.nil? # It's a gap
          
          # Press direction
          new_presses = presses + 1
          new_state = [new_pos, current_index]
          
          unless visited.include?(new_state)
            queue << [new_pos, current_index, new_presses]
            visited.add(new_state)
          end
        end
      end
    end
    
    # If BFS completes without reaching goal
    Float::INFINITY
  end

  
  def compute_sum_complexities(codes, numeric_keypad, directional_keypad)
    total_complexity = 0
    complexities = {}
    
    codes.each do |code|
      presses = bfs_min_presses(code, numeric_keypad, directional_keypad)
      numeric_part = extract_numeric_part(code)
      complexity = presses * numeric_part
      
      complexities[code] = { presses: presses, numeric_part: numeric_part, complexity: complexity }
      total_complexity += complexity
    end
    
    # Output
    complexities.each do |code, data|
      if data[:presses] == Float::INFINITY
        puts "Code: #{code} could not be typed due to invalid moves."
      else
        puts "Code: #{code}"
        puts "  Numeric Part: #{data[:numeric_part]}"
        puts "  Button Presses: #{data[:presses]}"
        puts "  Complexity: #{data[:complexity]}"
        puts
      end
    end
    
    puts "Total Complexity: #{total_complexity}"
  end

  
  # Define the five codes
codes = [
    "029A",
    "980A",
    "179A",
    "456A",
    "379A"
  ]
  
  # Compute the sum of complexities
  compute_sum_complexities(codes, NUMERIC_KEYPAD, DIRECTIONAL_KEYPAD)

  
  