# frozen_string_literal: true

def parse_file(path)
  cards = Hash.new { |hash, key| hash[key] = {} }
  File.readlines(path).each do |line|
    card, numbers = line.split(': ')
    card_id = card.split[1].to_i

    winning, candidates = numbers.split(' | ').map { |str| str.split.map(&:to_i) }

    cards[card_id]['winning'] = winning
    cards[card_id]['candidates'] = candidates
    cards[card_id]['winners'] = 0
    cards[card_id]['copies'] = 0
  end
  cards
end

def solve_part1(cards)
  score = 0
  cards.each_value do |v|
    winners = 0
    winning = v['winning']
    candidates = v['candidates']
    candidates.each do |num|
      winners += 1 if winning.include?(num)
    end
    score += winners.zero? ? 0 : 2**(winners - 1)
  end
  score
end

def solve_part2(cards)
  cards.each do |id, v|
    winning = v['winning']
    candidates = v['candidates']

    candidates.each do |num|
      cards[id]['winners'] += 1 if winning.include?(num)
    end

    next if cards[id]['winners'].zero?

    1.upto(cards[id]['winners']) do |i|
      cards[id + i]['copies'] += 1 + cards[id]['copies']
    end
  end

  total_cards = 0
  cards.each do |k, v|
    puts "#{k}: #{v['copies']}"
    total_cards += v['copies'] + 1
  end

  total_cards
end

path = 'Inputs/day-04.txt'
input = parse_file(path)
puts "part_1: #{solve_part1(input)}"
puts "part_2: #{solve_part2(input)}"
