def parse_input(path)
  File.read(path).split(/\n/)
    .map { |chunk| chunk.to_i}
end

def solve_part_1(numbers)
  #offset = 25
  range = 25

  (25..numbers.size-25).each_with_index do |idx| 

    found, val = find_sum(numbers[idx-range..idx-1], numbers[idx], range)

    return val unless found
  end
end

def find_sum(numbers, target, range)
  
  numbers.each_with_index do |num1, i|
    (i + 1).upto(numbers.length - 1) do |j|
      num2 = numbers[j]
      if num1 + num2 == target && num1 != num2
        return [true, 0]
      end
    end
  end
 
  [false, target]

end

def solve_part_2(numbers, target)
  offset = 0 
  sum = 0
  range = []
  sums = []
  #puts "STARTING\nsum: #{sum}, target: #{target}, offset: #{offset}"
  while (sum != target || range.size < 2) do
    break unless offset < 550
    #puts "sum: #{sum}"
    #p range
  
    #puts "sum: #{sum}, target: #{target}, offset: #{offset}"
    while range.size > 0 && sum > target do
     # puts "range.size > 0 && sum > target"
      #puts "sum: #{sum}, target: #{target}"
      #p range
      range.delete_at(0)
      sum = range.inject(:+)
      puts "summy: #{sum}"
      sums << sum
      #p range
    end
    return [true, range.sort] unless sum != target
    range.push(numbers[offset])
    offset += 1
    sum = range.inject(:+)
    if sum == nil
      sum = 0
    end
    sums << sum
    #puts "sum: #{sum}, target: #{target}, offset: #{offset}"
    #p range
  end

  found = sums.include?(target)
  puts found
  
end


file = "Inputs/day-09.txt"

numbers = parse_input(file)

part_1 = solve_part_1(numbers)
_, range = solve_part_2(numbers, part_1)

puts "part 1: #{part_1}"
puts "part 2: #{range[0]+range[range.size-1]}"