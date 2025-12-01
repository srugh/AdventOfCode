require 'set'

def parse_input(path)
  monkeys = Hash.new
  lines = File.readlines(path, chomp:true)

  lines.each do |line|
    m, a = line.split(": ")
    a = a.split
    if a.size == 1
      monkeys[m] = { now: a[0].to_i }
    else
      monkeys[m] = { later: a}
    end
  end

  monkeys
end

def solve_part_1(monkeys)
  

  yelled = Set.new
  while monkeys["root"].key?(:later)
    monkeys.select { |_id, rule| rule.key?(:now) }.each do |k,v|
      yelled.add(k)
      v[:foo] = v.delete(:now)
    end
  
    
    monkeys.select { |_id, rule| rule.key?(:later) }.each do |k,v|

      a = yelled.include?(v[:later].first)

      b =  yelled.include?(v[:later].last)

      if a && b
  
        if v[:later][1] == "*"
          v[:later] = monkeys[v[:later][0]][:foo] * monkeys[v[:later][2]][:foo]
          v[:now] = v.delete(:later)
       
        elsif v[:later][1] == "+"
          v[:later] = monkeys[v[:later][0]][:foo] + monkeys[v[:later][2]][:foo]
          v[:now] = v.delete(:later)
     
        elsif v[:later][1] == "-"
          v[:later] = monkeys[v[:later][0]][:foo] - monkeys[v[:later][2]][:foo]
          v[:now] = v.delete(:later)
     
        elsif v[:later][1] == "/"
          v[:later] = monkeys[v[:later][0]][:foo] / monkeys[v[:later][2]][:foo]
          v[:now] = v.delete(:later)
     
        elsif v[:later][1] == "="
           puts monkeys[v[:later][0]][:foo] - monkeys[v[:later][2]][:foo] 
          v[:later] = monkeys[v[:later][0]][:foo] == monkeys[v[:later][2]][:foo]
         
          v[:now] = v.delete(:later)
      
        end
        
      end
    end
    

  end
 
  monkeys["root"]

end

def solve_part_2(monkeys)
  root_job = monkeys["root"][:later]
  left_name, _, right_name = root_job  # ignore the original op (+, -, etc.)

  # f(h) = left(h) - right(h)
  f = ->(h) do
    lv = eval_monkey(monkeys, left_name, h)
    rv = eval_monkey(monkeys, right_name, h)
    lv - rv
  end

  # Find a range [lo, hi] such that f(lo) and f(hi) have opposite signs.
  lo = 0
  hi = 1
  while f.call(lo).signum == f.call(hi).signum
    hi *= 2
  end

  # binary search for zero in [lo, hi]
  while lo <= hi
    mid = (lo + hi) / 2
    v = f.call(mid)

    if v == 0
      return mid
    elsif v > 0
      # f decreases with h ⇒ move right if opposite; if your sign is flipped, swap branches
      lo = mid + 1
    else
      hi = mid - 1
    end
  end

  raise "no solution found"
end

class Integer
  def signum
    self <=> 0
  end
end

def eval_monkey(monkeys, name, humn_value = nil)
  # humn is special for part 2
  return humn_value if name == "humn" && !humn_value.nil?

  job = monkeys[name]

  # simple number case
  if job[:now]
    return job[:now]
  end

  a, op, b = job[:later]
  va = eval_monkey(monkeys, a, humn_value)
  vb = eval_monkey(monkeys, b, humn_value)

  case op
  when "+"
    va + vb
  when "-"
    va - vb
  when "*"
    va * vb
  when "/"
    va / vb
  else
    raise "unknown op #{op}"
  end
end


path = "Inputs/day-21.txt"
input = parse_input(path)
#part_1 = solve_part_1(input)

part_2 = solve_part_2(input)

#puts "part_1: #{part_1}"
puts "part_2: #{part_2}"
