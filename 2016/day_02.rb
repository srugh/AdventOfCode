# frozen_string_literal: true

def parse_input(path)
  File.read(path).split("\n")
end

def solve_part1(input)
  moves = {}
  moves['U'] = [-1, 0]
  moves['D'] = [1, 0]
  moves['L'] = [0, -1]
  moves['R'] = [0, 1]

  start_pos = [1, 1]
  code = ''
  pos = start_pos
  input.each do |steps|
    steps.each_char do |step|
      next_step = moves[step].zip(pos).map { |a, b| a + b }
      pos = next_step if in_bounds?(next_step)
    end
    code += calc_button(pos)
  end
  code
end

def calc_button(pos)
  case pos
  when [0, 0]
    '1'
  when [0, 1]
    '2'
  when [0, 2]
    '3'
  when [1, 0]
    '4'
  when [1, 1]
    '5'
  when [1, 2]
    '6'
  when [2, 0]
    '7'
  when [2, 1]
    '8'
  when [2, 2]
    '9'
  end
end

def in_bounds?(pos)
  pos[0].between?(0, 2) && pos[1] >= 0 && pos[1] <= 2
end

def solve_part2(input)
  moves = {}
  moves['U'] = [-1, 0]
  moves['D'] = [1, 0]
  moves['L'] = [0, -1]
  moves['R'] = [0, 1]

  start_pos = [2, 0]
  code = ''
  pos = start_pos
  input.each do |steps|
    steps.each_char do |step|
      next_step = moves[step].zip(pos).map { |a, b| a + b }
      pos = next_step if in_bounds_2?(next_step)
    end
    code += calc_button_2(pos)
  end
  code
end

def calc_button_2(pos)
  case pos
  when [0, 2]
    '1'
  when [1, 1]
    '2'
  when [1, 2]
    '3'
  when [1, 3]
    '4'
  when [2, 0]
    '5'
  when [2, 1]
    '6'
  when [2, 2]
    '7'
  when [2, 3]
    '8'
  when [2, 4]
    '9'
  when [3, 1]
    'A'
  when [3, 2]
    'B'
  when [3, 3]
    'C'
  when [4, 2]
    'D'
  end
end

def in_bounds_2?(pos)
  valid = Set.new
  valid.add([0, 2])

  valid.add([1, 1])
  valid.add([1, 2])
  valid.add([1, 3])

  valid.add([2, 0])
  valid.add([2, 1])
  valid.add([2, 2])
  valid.add([2, 3])
  valid.add([2, 4])

  valid.add([3, 1])
  valid.add([3, 2])
  valid.add([3, 3])

  valid.add([4, 2])

  valid.include?(pos)
end

path = 'Inputs/day-02.txt'
input = parse_input(path)
p solve_part1(input)
p solve_part2(input)
