

def solve_part_1(input)
  locs = input
  scores = Array.new(2, 0)
  die_sides = 100
  turn = 0
  rolls = (1..100).to_a
  while scores[0] < 1000 && scores[1] < 1000
    p = turn % 2

    one   = rolls[turn * 3 % die_sides]
    two   = rolls[(turn * 3 + 1) % die_sides]
    three = rolls[(turn * 3 + 2) % die_sides] 

    locs[p] = (locs[p] + one + two + three) % 10
    locs[p] = 10 if locs[p] == 0
    scores[p] += locs[p]

    #puts "Turn: #{turn}, Player: #{p}, #{one} + #{two} + #{three}.  Loc: #{locs[p]}, score: #{scores[p]}"
    #break if turn == 10
    turn += 1
  end

  p scores
  p turn
  scores.min * turn * 3

end

def solve_part_2(input)
  
end



input = [10,2]
#input = [4,8]
part_1 = solve_part_1(input)
part_2 = solve_part_2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"