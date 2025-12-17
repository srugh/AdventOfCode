# frozen_string_literal: true

def parse_input(path)
  File.read(path).split("\n").map(&:split)
end

def solve_part1(instructions)
  registers = {}
  registers['a'] = 7
  registers['b'] = 0
  registers['c'] = 0
  registers['d'] = 0
  offset = 0

  quit = 0
  puts "offset: #{offset}, a: #{registers['a']}, b: #{registers['b']}, c: #{registers['c']}, d: #{registers['d']}"
  while offset < instructions.size

    quit += 1

    # p registers
    # p instructions[offset]
    command, arg_1, arg_2 = instructions[offset]
    puts "command: #{command}, a1: #{arg_1}, a2: #{arg_2}"

    case command
    when 'cpy'
      arg_1 = %w[a b c d].include?(arg_1) ? registers[arg_1] : arg_1.to_i
      registers[arg_2] = arg_1 if %w[a b c d].include?(arg_2)
      offset += 1
    when 'inc'
      registers[arg_1] += 1
      offset += 1
    when 'dec'
      registers[arg_1] -= 1
      offset += 1
    when 'jnz'
      arg_1 = %w[a b c d].include?(arg_1) ? registers[arg_1] : arg_1.to_i
      arg_2 = %w[a b c d].include?(arg_2) ? registers[arg_2] : arg_2.to_i
      offset += arg_1.zero? ? 1 : arg_2
    when 'tgl'
      arg_1 = %w[a b c d].include?(arg_1) ? registers[arg_1] : arg_1.to_i
      if offset + arg_1 >= instructions.size
        offset += 1
        next
      end
      temp = instructions[offset + arg_1]

      case temp[0]
      when 'inc'
        instructions[offset + arg_1][0] = 'dec'
      when 'dec'
        instructions[offset + arg_1][0] = 'inc'
      when 'cpy'
        instructions[offset + arg_1][0] = 'jnz'
      when 'jnz'
        instructions[offset + arg_1][0] = 'cpy'
      when 'tgl'
        instructions[offset + arg_1][0] = 'inc'
      end
      offset += 1
    end
    puts "offset: #{offset}, a: #{registers['a']}, b: #{registers['b']}, c: #{registers['c']}, d: #{registers['d']}"
    puts
  end
  registers['a']
end

path = 'Inputs/day-23.txt'
input = parse_input(path)
p solve_part1(input)
