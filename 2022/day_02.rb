# frozen_string_literal: true

def parse_input(path)
  File.read(path).split("\n").map(&:split)
end

def solve_part1(input)
  total_score = 0
  input.each do |round|
    outcome_score = if (round[0] == 'A' && round[1] == 'X') ||
                       (round[0] == 'B' && round[1] == 'Y') ||
                       (round[0] == 'C' && round[1] == 'Z')
                      3
                    elsif (round[0] == 'A' && round[1] == 'Y') ||
                          (round[0] == 'B' && round[1] == 'Z') ||
                          (round[0] == 'C' && round[1] == 'X')
                      6
                    else
                      0
                    end

    played_score = if round[1] == 'X'
                     1
                   elsif round[1] == 'Y'
                     2
                   else
                     3
                   end

    total_score += outcome_score + played_score
  end
  total_score
end

def solve_part2(input)
  total_score = 0
  input.each do |round|
    outcome_score = 0
    my_hand = ''
    if round[1] == 'X'
      # lose
      my_hand = 'A' if round[0] == 'B'
      my_hand = 'B' if round[0] == 'C'
      my_hand = 'C' if round[0] == 'A'
      outcome_score = 0
    elsif round[1] == 'Y'
      my_hand = round[0]
      outcome_score = 3
    else
      my_hand = 'A' if round[0] == 'C'
      my_hand = 'B' if round[0] == 'A'
      my_hand = 'C' if round[0] == 'B'
      outcome_score = 6
    end

    played_score = if my_hand == 'A'
                     1
                   elsif my_hand == 'B'
                     2
                   else
                     3
                   end

    total_score += outcome_score + played_score
  end
  total_score
end

path = 'Inputs/day-02.txt'
input = parse_input(path)
part_1 = solve_part1(input)
part_2 = solve_part2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"
