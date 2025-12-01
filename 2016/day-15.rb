
def parse_input(path)
  discs = Hash.new {|hash, key| hash[key] = {}}
  lines = File.read(path).split(/\n/).map { |n| n.scan(/(\d+)/)}
  lines.each do |line|
    line = line.flatten
    discs[line[0].to_i]["positions"] = line[1].to_i
    discs[line[0].to_i]["at_time"] = line[2].to_i
    discs[line[0].to_i]["start_position"] = line[3].to_i
  end
  discs
end

def solve_part_1(discs)
 

  # time offset for each disk being at position 0
  return calc_offsets(discs)

end

def solve_part_2(discs)
  discs[7]["positions"] = 11
  discs[7]["at_time"] = 0
  discs[7]["start_position"] = 0

  return calc_offsets(discs)
end

def calc_offsets(discs)
  # First: compute per-disc offsets (one valid press time for each disc)
  discs.each do |k, v|
    level    = k
    position = v["positions"]
    start    = v["start_position"]

    0.upto(position * 2) do |i|
      # Find first i such that (level + i + start) % position == 0
      if (level + i + start) % position == 0
        # Store normalized offset (mod period)
        v["offset"] = i % position
        break
      end
    end
  end

  # Now combine all disc constraints into a single t
  levels      = discs.keys.sort
  first_level = levels.first
  first       = discs[first_level]

  t    = first["offset"] % first["positions"]   # first valid time for the first disc
  step = first["positions"]                     # period for the first disc

  levels[1..-1].each do |level|
    info      = discs[level]
    positions = info["positions"]
    offset    = info["offset"] % positions

    # Advance t in steps such that we don't break previous discs,
    # until this disc's constraint is also satisfied.
    until t % positions == offset
      t += step
    end

    # New combined period
    step = step.lcm(positions)
  end
  t
end


path = "Inputs/day-15.txt"
input = parse_input(path)
#p solve_part_1(input)
p solve_part_2(input)