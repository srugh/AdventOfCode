  def parse_input(path)
    rules = Hash.new
    msgs = []
    x, msgs = File.read(path).split(/\n\n/)
    .map {|chunk| chunk.split(/\n/)}

    x.each do |rule|
      key, foo = rule.split(":")
      bar = foo.split("|")
      temp = []

      bar.each do |q|
        y = q.chomp.split
        t = []
        y.each do |z|
          z = z.delete("\"")
          if z != "a" && z != "b"
            z = z.to_i
          end
          t.push(z)
    
        end
        temp.push(t)
        
      end
      rules[key.to_i] = temp
   
    end
    [rules, msgs]
  end



def solve_part_1(rules)
  first_rule = 0
  chain = []

  traverse(first_rule, rules, chain)
end

def traverse(rule, rules, chain)
  todo = rules[rule]
  while todo.size > 0
    next_rule = todo.shift
    traverse()
  end
  
end

  file = "Inputs/day-19.txt"
  file = "Inputs/day-19-sample.txt"

  rules, msgs = parse_input(file)

  part_1 = solve_part_1(rules, msgs)

  puts "part_1: #{part_1}"
