# frozen_string_literal: true

def parse_input(path)
  File.read(path).split("\n").map(&:split)
end

def solve_part1(instructions)
  storage = {}
  storage['w'] = 0
  storage['x'] = 0
  storage['y'] = 0
  storage['z'] = 0

  input = 99_999_999_999_999

  while input >= 11_111_111_111_111
    puts input if (input % 100_000).zero?
    input_chars = input.to_s.chars
    if input_chars.count('0').positive?
      input -= 1
      next
    end
    storage = {}
    storage['w'] = 0
    storage['x'] = 0
    storage['y'] = 0
    storage['z'] = 0
    instructions.each do |ins|
      action, left, right = ins
      case action
      when 'inp'
        storage[left] = input_chars.shift[0].to_i
      when 'add'
        storage[left] += storage.key?(right) ? storage[right] : right.to_i
      when 'mul'
        storage[left] *= storage.key?(right) ? storage[right] : right.to_i
      when 'div'
        right = storage.key?(right) ? storage[right] : right.to_i
        return 'divide by 0' if right.zero?

        storage[left] /= right
      when 'mod'
        right = storage.key?(right) ? storage[right] : right.to_i
        return 'mod contains a 0' if storage[left].negative? || right <= 0

        storage[left] %= right
      when 'eql'
        right = storage.key?(right) ? storage[right] : right.to_i
        storage[left] = storage[left] == right ? 1 : 0
      end
    end
    return storage[z] if storage['z'].zero?

    input -= 1
  end
  p storage
end

def solve_part2(input); end

path = 'Inputs/day-24.txt'
input = parse_input(path)
part_1 = solve_part1(input)
part_2 = solve_part2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"
