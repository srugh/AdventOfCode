def parse_input(path)
  stacks, steps = File.read(path).split(/\n\n/).map{|chunk| chunk.split(/\n/)}

  stacks.reverse!
  cols = stacks.shift
  temp = Hash.new
  cols.chars.each_with_index do |col, idx|
    if col != " "
      temp[col.to_i] = idx
    end
  end
  s = Hash.new { |hash, key| hash[key] = [] }
  exclude = ["[", "]", " "]
  stacks.each do |stack|

    temp.each do |k, v|
   
      if !exclude.include?(stack[v])
        s[k].push(stack[v])
      end
    end
  end

  q = []
 
  steps.each do |step|
    p = step.scan(/(\d+)/)
    p = p.flatten
    q.push([p[0].to_i, p[1].to_i, p[2].to_i])
  end
  [s, q]
end

def solve_part_1(stacks, steps)
  #p stacks
  steps.each do |step|
    count, from, to = step
    
    count.times do
      stacks[to].push(stacks[from].pop)
    end
  end
  str = ""
  stacks.each do |k, v|
    str += v.last
  end
  str
end

def solve_part_2(stacks, steps)
  steps.each do |step|
  count, from, to = step
    temp = []
    count.times do
      temp.push(stacks[from].pop)
    end
    count.times do
      stacks[to].push(temp.pop)
    end
  end
  str = ""
  p stacks
  stacks.each do |k, v|
    str += v.last
  end
  str
end


path = "Inputs/day-05.txt"
stacks, steps = parse_input(path)
#part_1 = solve_part_1(stacks.dup, steps.dup)
part_2 = solve_part_2(stacks.dup, steps.dup)

#puts "part_1: #{part_1}"
puts "part_2: #{part_2}"