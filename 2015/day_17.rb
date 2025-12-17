# frozen_string_literal: true

def parse_input(path)
  File.read(path).split("\n").map(&:to_i).sort
end

def solve_part1(jugs)
  perms = []

  jugs.size.times do |i|
    next if i.zero?

    perms[i] = []
    jugs.combination(i).each do |perm|
      perms[i].push(perm) if perm.sum == 150
    end
  end
  p1 = perms.size

  p perms[4]
  p2 = perms[4].size

  [p1, p2]
end

path = 'Inputs/day-17.txt'
input = parse_input(path)
p1, p2 = solve_part1(input)

p p1
puts
p p2
