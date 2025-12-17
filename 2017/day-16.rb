# frozen_string_literal: true

def parse_input(path)
  arr = []
  File.read(path).split(',').each do |move|
    m = move[0]
    case m
    when 's'
      n = move[1..]
      arr.push([m, n.to_i, 0])
    when 'x'
      a, b = move[1..].split('/')
      arr.push([m, a.to_i, b.to_i])
    when 'p'
      a, b = move[1..].split('/')
      arr.push([m, a, b])
    end
  end
  arr
end

def solve_part1(moves)
  programs = 'abcdefghijklmnop'

  moves.each do |move|
    m, a, b = move
    case m
    when 's'
      programs = programs[-a..] + programs[0...-a]
    when 'x'
      temp = programs[a]
      programs[a] = programs[b]
      programs[b] = temp
    when 'p'
      a_i = programs.index(a)
      b_i = programs.index(b)
      temp = programs[a_i]
      programs[a_i] = programs[b_i]
      programs[b_i] = temp
    end
  end
  programs
end

def dance_once(programs, moves)
  moves.each do |move|
    m, a, b = move
    case m
    when 's'
      programs = programs[-a..] + programs[0...-a]
    when 'x'
      programs = programs.dup
      programs[a], programs[b] = programs[b], programs[a]
    when 'p'
      programs = programs.dup
      a_i = programs.index(a)
      b_i = programs.index(b)
      programs[a_i], programs[b_i] = programs[b_i], programs[a_i]
    end
  end
  programs
end

def solve_part2(moves)
  start = 'abcdefghijklmnop'
  seen = {}           # state -> index
  states = []         # index -> state

  current = start
  i = 0

  loop do
    if seen.key?(current)
      cycle_start = seen[current]
      cycle_len   = i - cycle_start

      # We want the state after 1_000_000_000 dances
      target = 1_000_000_000

      # We only care about the part inside the cycle
      offset_in_cycle = (target - cycle_start) % cycle_len
      return states[cycle_start + offset_in_cycle]
    end

    seen[current] = i
    states << current

    current = dance_once(current, moves)
    i += 1
  end
end

path = 'inputs/day-16.txt'
moves = parse_input(path)
puts "part 1: #{solve_part1(moves)}"
puts "part 2: #{solve_part2(moves)}"
