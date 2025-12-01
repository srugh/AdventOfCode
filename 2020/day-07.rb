require 'set'

def parse_input_part_1(file)
    bags = Hash.new
    File.readlines(file, chomp:true).each do |line|
        temp = line.scan(/(\S+ \S+) bags?/).flatten
        bags[temp.shift] = temp
    end
    bags
end

def parse_input_part_2(file)
    bags = Hash.new
    File.readlines(file, chomp:true).each do |line|
        temp = line.scan(/(\d*)\s?(\S+ \S+) bags?/)
        bags[temp.shift[1]] = temp
    end
    bags
end

def solve_part_1(bags)
  desired = "shiny gold"
  answer_set = Set.new

  search_list = bags_containing(bags, desired)
  count = 0

  while search_list.size > 0 do
    process_bag = search_list.shift
    answer_set.add(process_bag)
    new_bags = bags_containing(bags, process_bag)

    search_list.push(*new_bags)

    count += 1
  end

  answer_set.size
end

def solve_part_2(bags)
  desired = "shiny gold"
  search_list = []

  search_list = bags[desired]
  total_bags = 0

  while search_list.size > 0 do
    process_bag = search_list.shift
    total_bags += process_bag[0].to_i

    process_bag[0].to_i.times do
      search_list.push(*bags[process_bag[1]])
    end

  end
  total_bags
end

def bags_containing(bags, desired)
    containing_bags = []
    bags.each do |key, value|
    if value.include?(desired)
      containing_bags.push(key)
    end
  end

  containing_bags
end

file = "Inputs/day-07.txt"

bags = parse_input_part_1(file)
bags_2 = parse_input_part_2(file)

part_1 = solve_part_1(bags)
part_2 = solve_part_2(bags_2)

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"