# frozen_string_literal: true

def parse_input(input)
  games = {}

  File.foreach(input) do |line|
    one = line.chomp.split(':')
    game_id = one[0].split.last.to_i

    matches = one[1].strip.split(';')

    match_array = []
    matches.each_with_index do |match, _idx|
      cubes = match.strip.split(',')

      cubes_array = []
      cubes.each do |cube|
        num, color = cube.strip.split
        cubes_array.push([color, num.to_i])
      end
      # p cubes_array
      match_array.push(cubes_array)
    end
    # p match_array
    games[game_id] = match_array
  end
  games
end

def calc_possible_games(games)
  actual_cubes = {}
  actual_cubes['red'] = 12
  actual_cubes['green'] = 13
  actual_cubes['blue'] = 14
  total = 0
  # puts "** p games **"
  # p games

  # puts "** p games[0] **"
  # p games[1]

  # p all_games
  (1..100).each do |i|
    game = games[i]
    red = 0
    green = 0
    blue = 0

    game.each do |match|
      match.each do |reveal|
        case reveal[0]
        when 'red'
          red = reveal[1] unless red > reveal[1]
        when 'green'
          green = reveal[1] unless green > reveal[1]
        when 'blue'
          blue = reveal[1] unless blue > reveal[1]
        end
      end
    end
    total += red * blue * green
    puts "red x blue x green: #{red} * #{blue} * #{green} = #{red * blue * green}"
  end
  puts total
end

input = 'Inputs/day-02.txt'
games = parse_input(input)

calc_possible_games(games)
