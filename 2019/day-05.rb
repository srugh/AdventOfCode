# frozen_string_literal: true

def parse_input(path)
  File.read(path).split(',').map(&:to_i)
end

def run_intcode(program, input_value)
  mem = program.dup
  ip = 0
  outputs = []

  read = lambda do |param_idx, modes|
    mode = (modes / (10**(param_idx - 1))) % 10
    val = mem[ip + param_idx]
    mode == 1 ? val : mem[val]
  end

  write_addr = lambda do |param_idx|
    mem[ip + param_idx] # always an address
  end

  loop do
    instr = mem[ip]
    opcode = instr % 100
    modes  = instr / 100

    case opcode
    when 1 # add
      a = read.call(1, modes)
      b = read.call(2, modes)
      dst = write_addr.call(3)
      mem[dst] = a + b
      ip += 4

    when 2 # mul
      a = read.call(1, modes)
      b = read.call(2, modes)
      dst = write_addr.call(3)
      mem[dst] = a * b
      ip += 4

    when 3 # input
      dst = write_addr.call(1)
      mem[dst] = input_value
      ip += 2

    when 4 # output
      val = read.call(1, modes)
      outputs << val
      ip += 2

    when 5 # jump - true
      a = read.call(1, modes)
      b = read.call(2, modes)
      ip = a.zero? ? ip + 3 : b

    when 6 # jump - false
      a = read.call(1, modes)
      b = read.call(2, modes)
      ip = a.zero? ? b : ip + 3

    when 7 # less than
      a = read.call(1, modes)
      b = read.call(2, modes)
      dst = write_addr.call(3)
      mem[dst] = a < b ? 1 : 0
      ip += 4

    when 8 # equal
      a = read.call(1, modes)
      b = read.call(2, modes)
      dst = write_addr.call(3)
      mem[dst] = a == b ? 1 : 0
      ip += 4

    when 99
      break

    else
      raise "unknown opcode #{opcode} at ip=#{ip} (instr=#{instr})"
    end
  end

  outputs
end

def solve_part1(program)
  run_intcode(program, 1)
end

def solve_part2(program)
  run_intcode(program, 5)
end

path = 'Inputs/day-05.txt'
program = parse_input(path)

puts "part 1: #{solve_part1(program)}"
puts "part 2: #{solve_part2(program)}"
