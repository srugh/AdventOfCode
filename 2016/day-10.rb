def parse_input(path)
  vals = []
  bots = Hash.new
  File.readlines(path, chomp:true).each do |line|
    chunks = line.split
    if chunks[0] == "value"
      val, to = chunks[1].to_i, chunks[5].to_i
      vals.push([val, to])
    elsif chunks[0] == "bot"
      type_l, low, type_h, high = chunks[5], chunks[6].to_i, chunks[10], chunks[11].to_i
      bots[chunks[1].to_i] = [type_l,low, type_h, high, []]
    end
  end
  [vals, bots]
end

def solve_part_1(vals, bots)
  vals.each do |val|
    bots[val[1]][4].push(val[0])
  end
  outputs = Hash.new{|hash, key|  hash[key] = []}

  round = 0
  while true do
    puts "round: #{round}"

    #puts
    bots.each do |bot, v|
      type_l, to_low, type_h, to_high, chips = v
      next if chips.size < 2
      puts "output: "
      return outputs[0][0] * outputs[1][0] * outputs[2][0] if outputs[0].size > 0 && outputs[1].size > 0 && outputs[2].size > 0
      #return bot if chips.min == 17 && chips.max == 61

      if type_l == "output"
        outputs[to_low].push(chips.min)
      else
        bots[to_low][4].push(chips.min)
      end

      if type_h == "output"
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

path = "Inputs/day-10.txt"
vals, bots = parse_input(path)
p solve_part_1(vals, bots)