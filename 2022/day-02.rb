def parse_input(path)
  File.read(path).split(/\n/).map{|s| s.split}
end

def solve_part_1(input)
  total_score = 0
  input.each do |round|
    outcome_score = 0
    played_score = 0
    
    if ((round[0] == "A" && round[1] == "X") ||
      (round[0] == "B" && round[1] == "Y") ||
      (round[0] == "C" && round[1] == "Z"))
      outcome_score = 3
    elsif ((round[0] == "A" && round[1] == "Y") ||
      (round[0] == "B" && round[1] == "Z") ||
      (round[0] == "C" && round[1] == "X"))
      outcome_score = 6
    else
      outcome_score = 0
    end

    if round[1] == "X"
      played_score = 1
    elsif round[1] == "Y"
      played_score = 2
    else
      played_score = 3
    end

    total_score += outcome_score + played_score
  end
  total_score
end

def solve_part_2(input)
  total_score = 0
  input.each do |round|
    outcome_score = 0
    played_score = 0
    my_hand = ""
    if round[1] == "X"
      # lose
      my_hand = "A" if round[0] == "B" 
      my_hand = "B" if round[0] == "C"
      my_hand = "C" if round[0] == "A"
      outcome_score = 0
    elsif round[1] == "Y"
      my_hand = round[0]
      outcome_score = 3
    else
      my_hand = "A" if round[0] == "C" 
      my_hand = "B" if round[0] == "A"
      my_hand = "C" if round[0] == "B"
      outcome_score = 6
    end

    if my_hand == "A"
      played_score = 1
    elsif my_hand == "B"
      played_score = 2
    else
      played_score = 3
    end

    total_score += outcome_score + played_score
  end
  total_score
  
end


path = "Inputs/day-02.txt"
input = parse_input(path)
part_1 = solve_part_1(input)
part_2 = solve_part_2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"