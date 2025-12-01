def parse_input(path)
  i = File.read(path).split(/\n/).map{|chunk| chunk.chomp.split(//)}
end

def solve_part_1(input)
  counts = Hash.new { |hash, key| hash[key] = 0 }
  p input
  input.each do |line|
    p line
    i = 0
    while line.size > 0
      t = line.pop
      if t == "0" || t == "1" || t == "2"
        t = t.to_i
      elsif t == "-"
        t = -1
      elsif t == "="
        t = -2
      end
      counts[i] += t
      i += 1
    end
    
  end

  dec = 0
  mult = 1
  str = "0"
  mults = Hash.new {|hash, key| hash[key] = 0 }
  counts.size.times do |i|
    str = str + "0"
    mults[i] = mult
    dec += counts[i] * mult
    mult *= 5
    
  end
  p counts
  p mults
  puts dec
 
  answer = Hash.new {|hash, key| hash[key] = 0 }
  (mults.size-1).downto(0) do |i|
    if mults[i] / dec > 2 && dec % mults[i] > 0
      puts "next"
      puts i
      next
    end
    puts "fits"
    puts dec
    puts mults[i]
    puts mults[i] / dec
    answer[i] = mults[i] / dec
    dec -= answer[i] * mults[i]

    
    
  end

  p answer
  
end

def solve_part_2(input)
  
end


path = "Inputs/day-25.txt"
input = parse_input(path)
input = [["1", "=", "-", "0", "-", "2"]]
part_1 = solve_part_1(input)
part_2 = solve_part_2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"