# frozen_string_literal: true

def read_data(input_file)
  File.read(input_file)
end

def calc_houses_visited(directions)
  moves = {}
  moves['^'] = [-1, 0]
  moves['>'] = [0, 1]
  moves['v'] = [1, 0]
  moves['<'] = [0, -1]

  houses_visited = []
  houses_visited.push([0, 0])

  santa_position = [0, 0]
  robo_santa_position = [0, 0]

  step = 0

  directions.each_char do |direction|
    if step.even?
      next_row = santa_position.last[0] + moves[direction][0]
      next_col = santa_position.last[1] + moves[direction][1]
      santa_position.push([next_row, next_col])
    else
      next_row = robo_santa_position.last[0] + moves[direction][0]
      next_col = robo_santa_position.last[1] + moves[direction][1]
      robo_santa_position.push([next_row, next_col])
    end
    houses_visited.push([next_row, next_col])
    step += 1
  end

  houses_visited.uniq.size
end

input_file = 'Inputs/day-03.txt'

directions = read_data(input_file)

puts "Total houses with a present #{calc_houses_visited(directions)}"
