


def solve_part_1(input)
  
  moves = 100
  moves = 10
  cur = 0

  cups = input.chars.map { |i| i.to_i}

  moves.times do
    picked_up = []
    open_spots = []
    # pick up 3 cups after cur cup
    (1..3).each_with_index do |idx|
      picked_up.push((cups[(cur+idx)%moves]))
      cups[(cur+idx)%moves] = ""
      open_spots.push((cur+idx)%moves)
    end

    # select destination cup
    dest = cups[cur] - 1
    found = !picked_up.include?(dest) && dest > 0
    while !found
      if picked_up.include?(dest)
        dest -= 1
      elsif dest < 1
        dest = 9
      end
      found = !picked_up.include?(dest) && dest > 0
    end

    # replace cups
    idx = cups.find_index(dest)
    temp = []
    

    # move/update current cup
    cur = (cur + 1) % moves
  end

end




start = "487912365"
start = "389125467"



part_1 = solve_part_1(start)
#part_2 = solve_part_2(numbers)

puts "part 1: #{part_1}"
#puts "part 2: #{part_2}"