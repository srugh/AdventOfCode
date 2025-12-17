# frozen_string_literal: true

def parse_input(path)
  File.read(path).split("\n")
      .map(&:split)
      .map { |chunk| [chunk[0], chunk[1].to_i] }
end

def solve_part1(instructions)
  offset = 0
  accumulator = 0
  visited = Set.new

  loop do
    return accumulator if visited.include?(offset)

    visited.add(offset)
    ins = instructions[offset]
    case ins[0]
    when 'nop'
      offset += 1
    when 'acc'
      accumulator += ins[1]
      offset += 1
    when 'jmp'
      offset += ins[1]
    end
  end
end

def solve_part2(instructions)
  offset = 0
  accumulator = 0
  visited = Set.new
  snapshot = [offset, accumulator]
  swapped = ''

  while offset < instructions.size
    puts "#{offset}, #{accumulator}, #{instructions[offset]}"
    if visited.include?(offset)
      visited.delete(offset)
      if swapped == 'jn'
        instructions[offset][0] = 'nop'
        swapped = ''
      end
      if swapped == 'nj'
        instructions[offset][0] = 'jmp'
        swapped = ''
      end

      offset = snapshot[0]
      accumulator = snapshot[1]
      if instructions[offset][0] == 'jmp'
        instructions[offset][0] = 'nop'
        swapped = 'jn'
      end
      if instructions[offset][0] == 'nop'
        instructions[offset][0] = 'jmp'
        swapped = 'nj'
      end
    end

    visited.add(offset)
    ins = instructions[offset]
    case ins[0]
    when 'nop'
      offset += 1
    when 'acc'
      accumulator += ins[1]
      offset += 1
    when 'jmp'
      offset += ins[1]
    end
    snapshot = [offset, accumulator]
  end

  accumulator
end

file = 'Inputs/day-08.txt'

instructions = parse_input(file)

part_1 = solve_part1(instructions)
part_2 = solve_part2(instructions)

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"
