
def solve_part_1(input)
  last_seen = Hash.new
 
  all_spoken = []
 
  (30000000).times do |i|
    if input.size > 0
      temp = input.shift
      last_seen[temp] = [i]
      all_spoken.push(temp)
      next
    end

    last_spoken = all_spoken.last
    instances = last_seen[last_spoken]

    if instances.size < 2
      all_spoken.push(0)
      if last_seen[0] == nil
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
  all_spoken[all_spoken.size-1]
end

input = [0,14,1,3,7,9]
#input = [3,1,2]
part_1 = solve_part_1(input)

puts "part_1: #{part_1}"