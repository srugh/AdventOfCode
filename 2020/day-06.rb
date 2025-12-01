
def parse_input(file)
  File.read(file)
  .split(/\n{2,}/)    
  .map { |chunk| chunk.split() }              
end

def solve_part_1(answers)
  counts = []
  answers.each do |answer| 

    group_string = ""
    answer.each do |foo|
      group_string << foo
    end

    counts.push(group_string.chars.uniq.size)
  end

  counts.inject(:+)
end

def solve_part_2(answers)
  counts = []

  answers.each do |answer| 

    
    group_hash = Hash.new
    answer.each do |foo|
      chars = foo.chars
      chars.each do |c|
        if !group_hash.has_key?(c)
          group_hash[c] = 0
        end
        group_hash[c] += 1
      end
    end
    count = 0
    group_hash.each do |key, value|
      if value == answer.size
        count += 1
      end
    end
    counts.push(count)
  end

  counts.inject(:+)
end

file = "Inputs/day-06.txt"

answers = parse_input(file)

part_1 = solve_part_1(answers)
part_2 = solve_part_2(answers)

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"