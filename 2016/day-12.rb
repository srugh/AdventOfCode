class AssembunnyInterpreter
    def initialize(instructions, initial_registers = { 'a' => 0, 'b' => 0, 'c' => 0, 'd' => 0 })
      @instructions = instructions
      @registers = initial_registers
      @pc = 0 # Program counter
    end
  
    def run
      while @pc < @instructions.size
        instr = @instructions[@pc]
        execute(instr)
      end
      @registers
    end
  
    private
  
    def get_value(x)
      if x =~ /^-?\d+$/
        x.to_i
      else
        @registers[x]
      end
    end
  
    def execute(instr)
      parts = instr.strip.split
      command = parts[0]
      case command
      when 'cpy'
        x, y = parts[1], parts[2]
        if valid_register?(y)
          @registers[y] = get_value(x)
        end
        @pc += 1
      when 'inc'
        x = parts[1]
        if valid_register?(x)
          @registers[x] += 1
        end
        @pc += 1
      when 'dec'
        x = parts[1]
        if valid_register?(x)
          @registers[x] -= 1
        end
        @pc += 1
      when 'jnz'
        x, y = parts[1], parts[2]
        if get_value(x) != 0
          offset = get_value(y)
          @pc += offset
        else
          @pc += 1
        end
      else
        # Unknown instruction
        @pc += 1
      end
    end
  
    def valid_register?(reg)
      %w[a b c d].include?(reg)
    end
  end
  
  # Replace this with your actual puzzle input
  instructions = File.readlines('Inputs/day-12-input.txt').map(&:strip)
  
  # Part One
  interpreter_part1 = AssembunnyInterpreter.new(instructions)
  final_registers_part1 = interpreter_part1.run
  puts "Part One - Register a: #{final_registers_part1['a']}"
  
  # Part Two
  initial_registers_part2 = { 'a' => 0, 'b' => 0, 'c' => 1, 'd' => 0 }
  interpreter_part2 = AssembunnyInterpreter.new(instructions, initial_registers_part2)
  final_registers_part2 = interpreter_part2.run
  puts "Part Two - Register a: #{final_registers_part2['a']}"
  