def parse_input(path)
  x = File.read(path).split(/\n\n/).map{|chunk| chunk.split(/\n/)}
  monkeys = Hash.new
  x.each do |y|
    m = y.shift
    s = y.shift
    o = y.shift
    t = y.shift
    r_t = y.shift
    t_f = y.shift

    monkey = m.scan(/(\d)/).flatten!.map{|i| i.to_i}
    start = s.scan(/(\d+)/).flatten!.map{|i| i.to_i}
      op_str   = o.split(" = ").last          # "old * 19" or "old * old"
    _, op_sym, rhs = op_str.split(" ")      # "old", "*", "19"/"old"
    operation =
      if rhs == "old"
        [:square]
      else
        [op_sym.to_sym, rhs.to_i]
      end
    test = t.scan(/(\d+)/).flatten!.map{|i| i.to_i}
    test_t = r_t.scan(/(\d)/).flatten!.map{|i| i.to_i}
    test_f = t_f.scan(/(\d)/).flatten!.map{|i| i.to_i}

    monkeys[monkey[0]] = [start, operation, test[0], test_t[0], test_f[0]]
  end
  
  monkeys
end
def simulate(monkeys, rounds:, relief_divisor:)
  # monkeys: hash like you build in parse_input
  inspected_count = Hash.new(0)

  # modulus = product of all divisors (LCM would be the “correct” general case)
  mod = monkeys.values.map { |(_, _, test, _, _)| test }.inject(1, :*)

  rounds.times do
    monkeys.size.times do |i|
      items, op, test, to_t, to_f = monkeys[i]

      # process everything this monkey currently holds
      while items.any?
        item = items.shift
        inspected_count[i] += 1

        # apply operation
        case op[0]
        when :square
          item = item * item
        when :*
          item = item * op[1]
        when :+
          item = item + op[1]
        else
          raise "unknown op #{op.inspect}"
        end

        # part 1 vs part 2:
        item /= relief_divisor if relief_divisor > 1

        # keep numbers bounded but preserve divisibility behavior
        item %= mod

        # test + throw
        if (item % test).zero?
          monkeys[to_t][0] << item
        else
          monkeys[to_f][0] << item
        end
      end
    end
  end

  inspected_count
end


def solve_part_1(input)
  inspected_count = Hash.new { |hash, key| hash[key] = 0 }
  rounds = 10000
  rounds.times do |round|
    puts "ROUND: #{round}"

    input.size.times do |i|
      puts i
      monkey = input[i]
      while monkey[0].size > 0 do 
        item = input[i][0].shift
        inspected_count[i] += 1
        #puts item
        op = ""
        by = 0
        if monkey[1] == nil
          op = "*"
          by = item
        else
          op = monkey[1].first
          by = monkey[1].last.to_i
        end
        if op == "*"
          item = item * by
        else
          item = item + by
        end
        #item = item / 3
        #puts "pushing"
        #puts item
        if item % monkey[2] == 0
          input[monkey[3]][0].push(item)
        else
          input[monkey[4]][0].push(item)
        end
      end
    end
  end
  p inspected_count
end

def solve_part_2(input)
  
end

path = "Inputs/day-11.txt"
input = parse_input(path)
ins2 = simulate(input, rounds: 10_000, relief_divisor: 1)
top2_2 = ins2.values.sort.last(2)
part_2 = top2_2[0] * top2_2[1]

path = "Inputs/day-11.txt"
input = parse_input(path)
#part_1 = solve_part_1(input)
#part_2 = solve_part_1(input)

#puts "part_1: #{part_1}"
puts "part_2: #{part_2}"