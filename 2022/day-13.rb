# frozen_string_literal: true

require 'json'

def parse_input(_path)
  File.read('Inputs/day-13.txt')
      .split("\n\n")
      .map { |blk| blk.lines.map(&:strip).reject(&:empty?).map { |s| JSON.parse(s) } }
end

def cmp(a, b)
  # returns -1 if a < b, 0 if equal, 1 if a > b under AoC rules
  if a.is_a?(Integer) && b.is_a?(Integer)
    a <=> b
  elsif a.is_a?(Array) && b.is_a?(Array)
    i = 0
    while i < a.length && i < b.length
      r = cmp(a[i], b[i])
      return r unless r.zero?

      i += 1
    end
    a.length <=> b.length
  else
    # mixed types: wrap the integer and retry
    a = [a] if a.is_a?(Integer)
    b = [b] if b.is_a?(Integer)
    cmp(a, b)
  end
end

def solve_part1(pairs)
  sum = 0
  pairs.each_with_index do |(left, right), idx|
    sum += (idx + 1) if cmp(left, right) == -1
  end
  sum
end

def solve_part2(pairs)
  packets = []
  pairs.each do |left, right|
    packets << left
    packets << right
  end

  packets.sort! { |a, b| cmp(a, b) }

  packets.each do |packet|
    p packet
  end

  (packets.index([[6]]) + 1) * (packets.index([[2]]) + 1)
end

path = 'Inputs/day-13.txt'
packets = parse_input(path)
# puts "part 1: #{solve_part1(packets)}"
puts "part 2: #{solve_part2(packets)}"
