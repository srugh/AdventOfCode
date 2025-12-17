# frozen_string_literal: true

def parse_input(path)
  File.readlines(path, chomp: true).map(&:split)
end

def val(arg, regs)
  # integer literal?
  if arg.match?(/\A-?\d+\z/)
    arg.to_i
  else
    regs[arg] # unknown => 0 because of Hash.new(0)
  end
end

def solve_part1(instructions)
  registers = Hash.new { 0 }
  offset = 0
  instructions_size = instructions.size

  while offset.between?(0, instructions_size)
    inst, x, y = instructions[offset]
    case inst
    when 'snd'

    when 'set'
      registers[x] = val(y, registers)
    when 'add'
      registers[x] += val(y, registers)
    when 'mul'
      registers[x] *= val(y, registers)
    when 'mod'
      registers[x] %= val(y, registers)
    when 'rcv'

    when 'jgz'
      if registers[x].positive?
        offset += val(y, registers)
        next
      end
    end
    offset += 1
  end
end

def handle_instruction(instruction, _sender, _shared)
  inst, x, y = instruction
  case inst
  when 'snd'

  when 'set'
    registers[x] = val(y, registers)
  when 'add'
    registers[x] += val(y, registers)
  when 'mul'
    registers[x] *= val(y, registers)
  when 'mod'
    registers[x] %= val(y, registers)
  when 'rcv'
    p registers
    sound unless registers[x].zero?
  when 'jgz'
    offset + val(y, registers) if registers[x].positive?
  end
end

def solve_part2(_instructions)
  shared = Hash.new { |hash, key| hash[key] = {} }
  shared[0]['registers']['p'] = 0
  shared[0]['offset'] = 0
  shared[0]['messages'] = []
  shared[1]['registers']['p'] = 1
  shared[1]['offset'] = 0
  shared[1]['messages'] = []
end

path = 'inputs/day-18.txt'
instructions = parse_input(path)
# puts "part 1: #{solve_part1(instructions)}"

puts "part 2: #{solve_part2(instructions)}"
