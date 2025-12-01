require 'set'
def parse_input(path)
  happiness = Hash.new  { |hash, key| hash[key] = {} }
  File.readlines(path, chomp: true).each do |line|
    line.delete_suffix!(".")
    temp = line.split
    val = temp[2] == "gain" ? temp[3].to_i : ("-" + temp[3]).to_i
    happiness[temp[0]][temp.last] = val
  end
  p happiness
  happiness
  
end

def total_happiness(order, happiness)
  n = order.size
  sum = 0

  n.times do |i|
    a = order[i]
    b = order[(i + 1) % n] # wrap around the circle

    sum += happiness[a][b]
    sum += happiness[b][a]
  end

  sum
end


def add_me(happiness)
  me = "Me"
  # outer hash already has the default { |h, k| h[k] = {} }, so this works:
  happiness.keys.each do |person|
    happiness[me][person] = 0
    happiness[person][me] = 0
  end
end

def solve_part_1(happiness)
  people = happiness.keys
  first  = people.first
  rest   = people[1..]

  best = -Float::INFINITY

  rest.permutation.each do |perm|
    seating = [first] + perm
    score = total_happiness(seating, happiness)
    best = score if score > best
  end

  best
end



path = "Inputs/day-13.txt"
input = parse_input(path)
add_me(input)
part_1 = solve_part_1(input)

puts "part_1: #{part_1}"