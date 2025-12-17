# frozen_string_literal: true

def parse_input(path)
  File.read(path).split(',').map(&:to_i)
end

def solve_part2(program, desired)
  99.times do |i|
    99.times do |j|
      program[1] = i
      program[2] = j
      return (100 * i) + j if desired == run(program.dup)
    end
  end
end

def run(program)
  offset = 0
  loop do
    opcode = program[offset]
    case opcode
    when 1
      op1, op2, store = program[offset + 1, 3]
      offset += 4
      program[store] = program[op1] + program[op2]
    when 2
      op1, op2, store = program[offset + 1, 3]
      offset += 4
      program[store] = program[op1] * program[op2]
    when 99
      break
    end
  end
  program[0]
end

path = 'Inputs/day-02.txt'
program = parse_input(path)
desired = 19_690_720
puts "part 2: #{solve_part2(program, desired)}"
