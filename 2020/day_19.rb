# frozen_string_literal: true

def parse_input(path)
  rules = {}
  x, msgs = File.read(path).split("\n\n")
                .map { |chunk| chunk.split("\n") }

  x.each do |rule|
    key, foo = rule.split(':')
    bar = foo.split('|')
    temp = []

    bar.each do |q|
      y = q.chomp.split
      t = []
      y.each do |z|
        z = z.delete('"')
        z = z.to_i if z != 'a' && z != 'b'
        t.push(z)
      end
      temp.push(t)
    end
    rules[key.to_i] = temp
  end
  [rules, msgs]
end

def solve_part1(rules)
  first_rule = 0
  chain = []

  traverse(first_rule, rules, chain)
end

def traverse(rule, rules, _chain)
  todo = rules[rule]
  while todo.size.positive?
    todo.shift
    traverse
  end
end
file = 'Inputs/day-19-sample.txt'

rules, msgs = parse_input(file)

part_1 = solve_part1(rules, msgs)

puts "part_1: #{part_1}"
