require 'set'
#tot_elves = 5
tot_elves = 3017957

elves = Set.new(1..tot_elves)

puts elves.size
remove = false
while elves.size > 1
    elves.each do |elf|
        if remove && elves.size > 1
            elves.delete(elf)
        end
        remove = !remove
    end
end

puts elves



def solve_part2(total_elves)
     # Split the circle into two halves
  left = (1..(total_elves / 2)).to_a
  right = ((total_elves / 2) + 1..total_elves).to_a
puts left.size
puts right.size
  while left.size + right.size > 1
    if (left.size + right.size) % 10000 == 0
        puts left.size + right.size
    end
    if left.size > right.size
      # Remove the first Elf from the left half
      left.shift
    else
      # Remove the first Elf from the right half
      right.shift
    end

    # Move the first Elf in the right half to the end of the left half
    left.unshift(right.shift) if !right.empty?

    # Swap the left and right halves
    left, right = right, left
  end
puts left.size
puts right.size
  # The last remaining Elf
  right.first
  end
  

  puts "Part 2 solution: #{solve_part2(tot_elves)}"
  