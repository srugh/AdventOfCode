# frozen_string_literal: true

# Tokenize into numbers and symbols
def tokenize(s)
  s.scan(/\d+|[()+*]/)
end

# atom := NUMBER | "(" expr ")"
def parse_atom(ts, i)
  if ts[i] == '('
    val, i = parse_mul(ts, i + 1) # parse full expr inside
    i += 1 # consume ")"
    [val, i]
  else
    [ts[i].to_i, i + 1]
  end
end

# add := atom { "+" atom }*
def parse_add(ts, i)
  val, i = parse_atom(ts, i)
  while i < ts.length && ts[i] == '+'
    rhs, i = parse_atom(ts, i + 1)
    val += rhs
  end
  [val, i]
end

# mul := add { "*" add }*
def parse_mul(ts, i)
  val, i = parse_add(ts, i)
  while i < ts.length && ts[i] == '*'
    rhs, i = parse_add(ts, i + 1)
    val *= rhs
  end
  [val, i]
end

def evaluate_line(s)
  ts = tokenize(s.delete(' '))
  val, = parse_mul(ts, 0)
  val
end

def sum_of_homework(path)
  total = 0
  File.readlines(path, chomp: true).each do |line|
    next if line.strip.empty?

    total += evaluate_line(line)
  end
  total
end

file = 'Inputs/day-18.txt'

puts sum_of_homework(file)
