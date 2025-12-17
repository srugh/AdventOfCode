# frozen_string_literal: true

def parse_input(path)
  firewall = {}
  File.readlines(path, chomp: true).each do |line|
    l, d = line.split(': ')
    firewall[l.to_i] = d.to_i
  end
  firewall
end

def solve_part1(firewall)
  scanner_tic = 0
  pos = -1
  final_layer = firewall.keys.max
  score = 0
  while final_layer != pos
    pos += 1
    score += pos * firewall[pos] if firewall.key?(pos) && (scanner_tic % ((firewall[pos] - 1) * 2)).zero?
    scanner_tic += 1
  end
  score
end

def solve_part2(firewall)
  final_layer = firewall.keys.max
  a_lambda = lambda do |tic|
    pos = -1
    while final_layer != pos
      pos += 1
      return false if firewall.key?(pos) && (tic % ((firewall[pos] - 1) * 2)).zero?

      tic += 1
    end
    true
  end

  (0..).each do |scanner_tic|
    next unless a_lambda.call(scanner_tic)

    return scanner_tic
  end
end

path = 'inputs/day-13.txt'
firewall = parse_input(path)
puts "part 1: #{solve_part1(firewall)}"
puts "part 2: #{solve_part2(firewall)}"
