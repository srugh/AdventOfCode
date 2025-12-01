def solve_part_1(input)
  min, max = input

  count = 0
  min.upto(max) do |i|
    # criteria
    dbl, inc = false, true

    str = i.to_s
    (str.length - 1).times do |j|
      if str[j].to_i > str[j+1].to_i
        inc = false
      end

      if str[j] == str[j+1]
        dbl = true
      end
    end
    count += 1 if dbl && inc
  end
  count
end

def solve_part_2(input)
  min, max = input

  count = 0
  min.upto(max) do |i|
    # criteria
    dbl, dbl_2, inc, = false, false, true

    str = i.to_s
    (str.length - 1).times do |j|
      if str[j].to_i > str[j+1].to_i
        inc = false
      end

      if str[j] == str[j+1] 
        dbl = true
        if str.count(str[j]) == 2
          dbl_2 = true
        end
      end
    end
    count += 1 if dbl && inc && dbl_2
  end
  count
end
input = [387638, 919123]
p_1 = solve_part_1(input)
p_2 = solve_part_2(input)

puts "p_1: #{p_1}"
puts "p_2: #{p_2}"
