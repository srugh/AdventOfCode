def parse_input(path)
  File.read(path).split(/\n/).map {|s| s.split("->")
    .map{|r| r.strip.split(',')
    .map(&:to_i)}}
end

def solve_part_1(input)
  vents = Hash.new {|hash, key| hash[key] = 0}
  input.each do |line|
    p1, p2 = line

    dir = "vert" if p1[0] == p2[0] 
    dir = "hor" if p1[1] == p2[1] 
    if dir == "vert"
      (([p1[1], p2[1]].min)..([p1[1], p2[1]].max)).each do |i|
        vents [[p1[0], i]] += 1
      end
    elsif dir == "hor"
      (([p1[0], p2[0]].min)..([p1[0], p2[0]].max)).each do |i|
        vents [[i, p1[1]]] += 1
      end
    end
  end
  vents.select { |key, value| value > 1 }.keys.count
end

def solve_part_2(input)
  vents = Hash.new {|hash, key| hash[key] = 0}
  input.each do |line|
    p1, p2 = line
    dir = ""
    dir = "vert" if p1[0] == p2[0] 
    dir = "hor" if p1[1] == p2[1] 
    mids = []

    if dir == "vert"
      (([p1[1], p2[1]].min)..([p1[1], p2[1]].max)).each do |i|
        vents [[p1[0], i]] += 1
      end
    elsif dir == "hor"
      (([p1[0], p2[0]].min)..([p1[0], p2[0]].max)).each do |i|
        vents [[i, p1[1]]] += 1
      end
    else
      mids = p1

      vents[[mids[0], mids[1]]] += 1
      while mids != p2
        mids[0] += mids[0] < p2[0] ? 1 : -1
        mids[1] += mids[1] < p2[1] ? 1 : -1
        vents[[mids[0], mids[1]]] += 1
      end

    end
  end
  vents.select { |key, value| value > 1 }.keys.count
end


path = "Inputs/day-05.txt"
input = parse_input(path)
part_1 = solve_part_1(input)
part_2 = solve_part_2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"