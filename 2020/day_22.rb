# frozen_string_literal: true

def parse_input(path)
  p1 = []
  p2 = []
  switch = false
  File.readlines(path, chomp: true).each do |line|
    if line == ''
      switch = true
      next
    end
    if switch
      p2.push(line.to_i)
    else
      p1.push(line.to_i)
    end
  end
  [p1, p2]
end

def solve_part1(p1, p2)
  while p1.size.positive? && p2.size.positive?
    c1 = p1.shift
    c2 = p2.shift
    if c1 > c2
      p1 << c1
      p1 << c2
    else
      p2 << c2
      p2 << c1
    end
  end

  score = 0
  if p1.size.positive?
    (0..(p1.size - 1)).each do |idx|
      score += p1[idx] * (p1.size - idx)
    end
  else
    (0..(p2.size - 1)).each do |idx|
      score += p2[idx] * (p2.size - idx)
    end
  end
  score
end

def start_mini_game?(c1, p1_size, c2, p2_size)
  return true if c1 <= p1_size && c2 <= p2_size

  false
end

def solve_part2(p1, p2)
  _, deck = side_game(p1.dup, p2.dup)

  score = 0

  (0..(deck.size - 1)).each do |idx|
    score += deck[idx] * (deck.size - idx)
  end

  score
end

def side_game(p1, p2)
  seen = Set.new

  while p1.size.positive? && p2.size.positive?
    key = "#{p1.join(',')}|#{p2.join(',')}"
    if seen.include?(key)
      return ['p1', p1] # player 1 wins the entire game immediately
    end

    seen.add(key)

    c1 = p1.shift
    c2 = p2.shift

    if start_mini_game?(c1, p1.size, c2, p2.size)

      winner, = side_game(p1[0..(c1 - 1)], p2[0..(c2 - 1)])
      if winner == 'p1'
        p1 << c1
        p1 << c2
      else
        p2 << c2
        p2 << c1
      end
    elsif c1 > c2

      p1 << c1
      p1 << c2
    else
      p2 << c2
      p2 << c1
    end
  end

  winner = ''
  winning_deck = []
  if p1.size.positive?
    winner = 'p1'
    winning_deck = p1
  else
    winner = 'p2'
    winning_deck = p2
  end
  [winner, winning_deck]
end

file = 'Inputs/day-20.txt'
# file = "Inputs/day-20-sample.txt"
p1, p2 = parse_input(file)

part_1 = solve_part1(p1.dup, p2.dup)

part_2 = solve_part2(p1.dup, p2.dup)

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"
