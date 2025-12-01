

tot = 0
File.read("Inputs/day-01.txt").split(/\n/).map {|i| i.to_i}.each do |mass|
  mod_fuel = mass / 3 - 2
  tot += mod_fuel

  while mod_fuel / 3 - 2 > 0
    mod_fuel = mod_fuel / 3 - 2
    tot += mod_fuel
  end
end

puts tot
