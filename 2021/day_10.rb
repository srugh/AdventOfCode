# frozen_string_literal: true

def parse_input(path)
  File.read(path).split("\n").map(&:chars)
end

def solve_part1(input)
  open_chunks = ['(', '[', '{', '<']
  close_chunks = [')', ']', '}', '>']

  total = 0
  part_2 = []
  input.each do |line|
    open_stack = []
    bad = false
    line.each do |c|
      open_stack.push(c) if open_chunks.include?(c)
      next unless close_chunks.include?(c)

      pair = open_stack.pop
      comp = ''
      score = 0
      case c
      when ')'
        comp = '('
        score = 3
      when ']'
        comp = '['
        score = 57
      when '}'
        comp = '{'
        score = 1197
      when '>'
        comp = '<'
        score = 25_137
      end
      if pair != comp
        total += score
        bad = true
      end
    end
    next if bad

    total_2 = 0
    while open_stack.size.positive?
      x = open_stack.pop
      score_2 = 0
      case x
      when '('
        score_2 = 1
      when '['
        score_2 = 2
      when '{'
        score_2 = 3
      when '<'
        score_2 = 4
      end
      total_2 = (total_2 * 5) + score_2
    end
    part_2.push(total_2)
  end
  sorted = part_2.sort
  p2 = sorted[(sorted.size / 2)]
  p p2
end

def solve_part2(input); end

path = 'Inputs/day-10.txt'
# path = "Inputs/day-10-sample.txt"
input = parse_input(path)
part_1 = solve_part1(input)
part_2 = solve_part2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"
