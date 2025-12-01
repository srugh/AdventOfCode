def parse_input(path)
  File.readlines(path, chomp: true).map do |line|
    [line[0], line[1..].to_i] # [direction, clicks]
  end
end

def solve_part_1(moves)
  zeros, pos, max_pos = 0, 50, 100

  moves.each do |dir, clicks|
    if dir == "R"
      pos = (pos + clicks) % max_pos
    else
      pos = (pos - clicks) % max_pos
    end
    zeros += 1 if pos == 0
  end

  zeros
end

def solve_part_2(inputs)
  zeros, pos, max_pos = 0, 50, 100

  inputs.each do |dir, clicks|
    if dir == "R"
      zeros += (pos + clicks) / max_pos
      pos = (pos + clicks) % max_pos
    else
      l_zeros =
        if pos == 0
          clicks / max_pos
        elsif clicks < pos
          0
        else
          1 + (clicks - pos) / max_pos
        end
      zeros += l_zeros
      pos = (pos - clicks) % max_pos
    end
  end

  zeros
end

path = "Inputs/day-01.txt"
moves = parse_input(path)
puts "Answer for part 1: #{solve_part_1(moves)}"
puts "Answer for part 2: #{solve_part_2(moves)}"