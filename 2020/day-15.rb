# frozen_string_literal: true

def solve_part1(input)
  last_seen = {}

  all_spoken = []

  30_000_000.times do |i|
    if input.size.positive?
      temp = input.shift
      last_seen[temp] = [i]
      all_spoken.push(temp)
      next
    end

    last_spoken = all_spoken.last
    instances = last_seen[last_spoken]

    if instances.size < 2
      all_spoken.push(0)
      if last_seen[0].nil?
        instances = [i]
      else
        instances = last_seen[0]
        instances.push(i)
      end

      last_seen[0] = instances
    else
      oldest = instances.shift
      recent = instances[0]
      last_seen[last_spoken] = [recent]
      last_spoken = recent - oldest
      temp = last_seen[last_spoken].to_a
      temp.push(i)
      last_seen[last_spoken] = temp
      all_spoken.push(last_spoken)
    end
  end
  all_spoken[all_spoken.size - 1]
end

input = [0, 14, 1, 3, 7, 9]
# input = [3,1,2]
part_1 = solve_part1(input)

puts "part_1: #{part_1}"
