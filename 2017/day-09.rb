# frozen_string_literal: true

def solve(str)
  skip = false
  in_garbage = false
  group_score = garbage_score = 0
  opens = 0

  str.chars.each do |ch|
    if skip
      skip = false
      next
    end

    if ch == '!'
      skip = true
    elsif in_garbage
      if ch == '>'
        in_garbage = false
      else
        garbage_score += 1
      end
    else
      case ch
      when '<'
        in_garbage = true
      when '{'
        opens += 1
      when '}'
        opens -= 1
        group_score += opens + 1
      end
    end
  end

  "part 1: #{group_score}, part 2: #{garbage_score}"
end

path = 'Inputs/day-09.txt'
str = File.read(path)
puts solve(str)
