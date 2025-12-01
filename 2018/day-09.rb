require 'set'

def sim_game(tot_players, last_marble)
    scores = Array.new(tot_players, 0)
    tot_marbles = last_marble + 1
    
    circle = []
    turns = []
    circle.push(0)
    idx = 0
    turn_num = 1
    #turns.push(circle.dup)

    while turn_num <= tot_marbles
        #puts "Turn: #{turn_num} \t Index: #{idx} \t Circle_size: #{circle.size}"
        if turn_num % 500 == 0
            puts "turn: #{turn_num}"
        end
        if turn_num % 23 != 0
            next_idx = calc_next_idx(circle, idx)
            circle.insert(next_idx, turn_num)
            idx = next_idx
        elsif turn_num % 23 == 0
            scores[turn_num % tot_players] += calc_score(circle, idx, turn_num)
            
            circle.delete_at(idx-7)
            idx -= 7
        end
        #turns.push(circle.dup)
        turn_num += 1
        
    end
    puts "Turn: #{turn_num} \t Index: #{idx} \t Circle_size: #{circle.size}"
    #print_turns(turns, tot_players)

    
    scores.max
end

def calc_score(circle, idx, turn_num)
    #scoring chip value
    scoring_chip = (turn_num / 23) * 23

    #extra chip value
    extra_chip = circle[idx-7]


    scoring_chip + extra_chip

end

def print_turns(turns, tot_players)
    turns.each_with_index do |turn, t|
        print "#{t % tot_players}: "
        p turn
    end
end

def calc_next_idx(circle, idx)
    next_idx = idx + 2

    if next_idx > circle.size
        next_idx -= circle.size
    end
      
    next_idx
end




tot_players = 425
last_marble = 7084800

highest_score = sim_game(tot_players, last_marble)

puts "highest_score: #{highest_score}"