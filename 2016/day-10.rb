# frozen_string_literal: true

def parse_input(path)
  vals = []
  bots = {}
  File.readlines(path, chomp: true).each do |line|
    chunks = line.split
    if chunks[0] == 'value'
      val = chunks[1].to_i
      to = chunks[5].to_i
      vals.push([val, to])
    elsif chunks[0] == 'bot'
      type_l = chunks[5]
      low = chunks[6].to_i
      type_h = chunks[10]
      high = chunks[11].to_i
      bots[chunks[1].to_i] = [type_l, low, type_h, high, []]
    end
  end
  [vals, bots]
end

def solve_part1(vals, bots)
  vals.each do |val|
    bots[val[1]][4].push(val[0])
  end
  outputs = Hash.new { |hash, key| hash[key] = [] }

  round = 0
  loop do
    puts "round: #{round}"

    # puts
    bots.each do |bot, v|
      type_l, to_low, type_h, to_high, chips = v
      next if chips.size < 2

      puts 'output: '
      if outputs[0].size.positive? && outputs[1].size.positive? && outputs[2].size.positive?
        return outputs[0][0] * outputs[1][0] * outputs[2][0]
      end

      # return bot if chips.min == 17 && chips.max == 61

      if type_l == 'output'
        outputs[to_low].push(chips.min)
      else
        bots[to_low][4].push(chips.min)
      end

      if type_h == 'output'
        outputs[to_high].push(chips.max)
      else
        bots[to_high][4].push(chips.max)
      end

      bots[bot][4] = []
    end
    round += 1
    puts
  end
end

path = 'Inputs/day-10.txt'
vals, bots = parse_input(path)
p solve_part1(vals, bots)
