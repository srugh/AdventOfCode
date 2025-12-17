# frozen_string_literal: true

def parse_input(path)
  hash = Hash.new { |hash, key| hash[key] = '' }
  File.read(path).split("\n").each do |s|
    s.chars.each_with_index do |c, i|
      hash[i] += c
    end
  end
  hash
end

def solve_part1(input)
  str = ''
  input.each do |k, v|
    counts = {}
    v.chars.uniq.each do |c|
      counts[c] = input[k].count(c)
    end
    str += counts.max_by { |_key, value| value }&.first
  end
  str
end

def solve_part2(input)
  str = ''
  input.each do |k, v|
    counts = {}
    v.chars.uniq.each do |c|
      counts[c] = input[k].count(c)
    end
    str += counts.min_by { |_key, value| value }&.first
  end
  str
end

path = 'Inputs/day-06.txt'
input = parse_input(path)
p solve_part1(input)
p solve_part2(input)
