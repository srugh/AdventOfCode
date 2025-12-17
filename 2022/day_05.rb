# frozen_string_literal: true

def parse_input(path)
  stacks, steps = File.read(path).split("\n\n").map { |chunk| chunk.split("\n") }

  stacks.reverse!
  cols = stacks.shift
  temp = {}
  cols.chars.each_with_index do |col, idx|
    temp[col.to_i] = idx if col != ' '
  end
  s = Hash.new { |hash, key| hash[key] = [] }
  exclude = ['[', ']', ' ']
  stacks.each do |stack|
    temp.each do |k, v|
      s[k].push(stack[v]) unless exclude.include?(stack[v])
    end
  end

  q = []

  steps.each do |step|
    p = step.scan(/(\d+)/)
    p = p.flatten
    q.push([p[0].to_i, p[1].to_i, p[2].to_i])
  end
  [s, q]
end

def solve_part1(stacks, steps)
  # p stacks
  steps.each do |step|
    count, from, to = step

    count.times do
      stacks[to].push(stacks[from].pop)
    end
  end
  str = ''
  stacks.each_value do |v|
    str += v.last
  end
  str
end

def solve_part2(stacks, steps)
  steps.each do |step|
    count, from, to = step
    temp = []
    count.times do
      temp.push(stacks[from].pop)
    end
    count.times do
      stacks[to].push(temp.pop)
    end
  end
  str = ''
  p stacks
  stacks.each_value do |v|
    str += v.last
  end
  str
end

path = 'Inputs/day-05.txt'
stacks, steps = parse_input(path)
# part_1 = solve_part1(stacks.dup, steps.dup)
part_2 = solve_part2(stacks.dup, steps.dup)

# puts "part_1: #{part_1}"
puts "part_2: #{part_2}"
