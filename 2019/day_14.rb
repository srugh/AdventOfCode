# frozen_string_literal: true

def parse_input(path)
  reactions = {}

  File.readlines(path, chomp: true).each do |line|
    lhs, rhs = line.split(' => ')

    out_qty, out_chem = rhs.split
    inputs = lhs.split(', ').map do |chunk|
      qty, chem = chunk.split
      [chem, qty.to_i]
    end

    reactions[out_chem] = {
      out: out_qty.to_i,
      inputs: inputs
    }
  end

  reactions
end

def ore_for(chem, amount, reactions, leftovers)
  return amount if chem == 'ORE'

  # use leftovers
  if leftovers[chem]&.positive?
    use = [amount, leftovers[chem]].min
    amount -= use
    leftovers[chem] -= use
  end

  return 0 if amount <= 0

  out_qty = reactions[chem][:out]
  inputs  = reactions[chem][:inputs]

  batches = (amount + out_qty - 1) / out_qty

  produced = batches * out_qty
  leftovers[chem] ||= 0
  leftovers[chem] += produced - amount

  ore = 0
  inputs.each do |in_chem, in_qty|
    ore += ore_for(in_chem, in_qty * batches, reactions, leftovers)
  end

  ore
end

def ore_for_fuel(fuel_amount, reactions)
  leftovers = Hash.new(0)
  ore_for('FUEL', fuel_amount, reactions, leftovers)
end

ORE_LIMIT = 1_000_000_000_000

def solve_part2(reactions)
  # Find an upper bound where ore_for_fuel(mid) > ORE_LIMIT
  low  = 1
  high = 1
  high *= 2 while ore_for_fuel(high, reactions) <= ORE_LIMIT

  # Binary search in [low, high)
  while low + 1 < high
    mid = (low + high) / 2
    ore_needed = ore_for_fuel(mid, reactions)

    if ore_needed <= ORE_LIMIT
      low = mid    # mid is feasible, try more
    else
      high = mid   # mid is too expensive, try less
    end
  end

  low # maximum fuel with <= ORE_LIMIT ORE
end

path = 'Inputs/day-14.txt'
reactions = parse_input(path)
leftovers = Hash.new(0)
puts ore_for('FUEL', 1, reactions, leftovers)
p solve_part2(reactions)
