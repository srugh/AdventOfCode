def parse_input(path)
  File.read(path).split(/\n/).map { |i| i.to_i}.sort
end

def solve_part_1(jugs)
  req = 150
  perms = []
  
  jugs.size.times do |i|
    next if i == 0
    perms[i] = []
    jugs.combination(i).each do |perm| 
      perms[i].push(perm) if perm.sum == 150
    end  
  
  end
 p1 = perms.size

 p perms[4]
 p2 = perms[4].size

 [p1,p2]
end

path = "Inputs/day-17.txt"
input = parse_input(path)
p1, p2 = solve_part_1(input)

p p1
puts
p p2

