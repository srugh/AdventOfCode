# frozen_string_literal: true

def solve_part1(earliest, buses)
  best_bus = 0
  best_time = -1
  valid_buses = buses.reject { |element| element == 'x' }

  valid_buses.each do |bus|
    mod = earliest % bus
    start = earliest - mod

    count = 1
    while start < earliest
      start += (count * bus)
      count += 1
    end
    if best_time == -1 || start < best_time
      best_bus = bus
      best_time = start
    end
  end
  (best_time - earliest) * best_bus
end

def solve_part2(buses)
  valid_buses = buses.reject { |element| element == 'x' }
  offsets = Array.new(valid_buses.size)
  valid_buses.each_with_index do |bus, idx|
    offsets[idx] = buses.find_index(bus)
  end

  t = 0
  step = 1
  valid_buses.each_with_index do |bus, idx|
    offset = offsets[idx]
    t += step while (t + offset) % bus != 0
    step = step.lcm(bus)
  end
  t
end
buses = [13, 'x', 'x', 'x', 'x', 'x', 'x', 37, 'x', 'x', 'x', 'x', 'x', 449, 'x', 29, 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x',
         'x', 'x', 'x', 'x', 19, 'x', 'x', 'x', 23, 'x', 'x', 'x', 'x', 'x', 'x', 'x', 773, 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 41, 'x', 'x', 'x', 'x', 'x', 'x', 17]
# buses = [7,13,"x","x",59,"x",31,19]

# part_1 = solve_part1(earliest, buses)
# puts "part_1: #{part_1}"

part_2 = solve_part2(buses)
puts "part_2: #{part_2}"
