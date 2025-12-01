require 'set'
def parse_input(path)
  temp = File.read(path).split(/\n\n/).map {|chunk| chunk.split(/\n/)}
  balls = temp.shift.join.split(",").map{|i| i.to_i}
  cards = []

  temp.each_with_index do |c, c_num|
    card_r = []
    card_c = Array.new(5) {[]}
 
    c.each_with_index do |r, idx|
      s = r.split.map{|i| i.to_i}
      card_r.push(s)
      
      s.each_with_index do |col, idy|
        card_c[idy][idx] = col
      end
    end
    cards.push(card_r + card_c)
      

    #cards.push(card)
  end
  [balls, cards]
end

def solve_part_1(balls, cards)
  winner = -1
  ball = -1
  while balls.size > 0 && winner == -1
    ball = balls.shift
    cards.each_with_index do |card, idx|
      card.each do |row|
        row.delete_if { |element| element == ball }
        if row.size == 0
          winner = idx
        end
      end
      return winner, ball, cards[winner].flatten.uniq.sum if winner != -1
    end
  end
end

def solve_part_2(balls, cards)
  last = -1
  ball = -1
  winners = Set.new
  while balls.size > 0 && winners.size != cards.size
    ball = balls.shift
    cards.each_with_index do |card, idx|
      next if winners.include?(idx)
      card.each do |row|
        row.delete_if { |element| element == ball }
        if row.size == 0
          winners.add(idx) 
          last = idx if winners.size == cards.size
        end
      end
    end
  end
  cards[last].flatten.uniq.sum * ball
end


path = "Inputs/day-04.txt"
balls, cards = parse_input(path)
#part_1 = solve_part_1(balls.clone, cards.clone)

part_2 = solve_part_2(balls, cards)


#puts "part_1: #{part_1}"
puts "part_2: #{part_2}"