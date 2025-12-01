def parse_input(file)
    seats = []
    File.readlines(file, chomp:true).each do |line|
        seats.push(line)
    end

    seats
end

def solve_part_1(seats)
  biggest = 0

  seats.each do |seat|

    l_row = 0
    h_row = 127

    l_col = 0
    h_col = 7

    (0..6).each do |i|
      tot_rows_in_range = h_row - l_row + 1
      midpoint_offset = tot_rows_in_range / 2

      if seat[i] == "F"
        h_row -= midpoint_offset
      else
        l_row += midpoint_offset
      end
    end

    
    (7..9).each do |i|
      tot_cols_in_range = h_col - l_col + 1
      midpoint_offset = tot_cols_in_range / 2

      if seat[i] == "L"
        h_col -= midpoint_offset
      else
        l_col += midpoint_offset
      end
    end

    id = l_row * 8 + l_col
    
    if id > biggest 
      biggest = id
    end
  end

  biggest
end

def solve_part_2(seats)
  booked = []

  seats.each do |seat|

    l_row = 0
    h_row = 127

    l_col = 0
    h_col = 7

    (0..6).each do |i|
      tot_rows_in_range = h_row - l_row + 1
      midpoint_offset = tot_rows_in_range / 2

      if seat[i] == "F"
        h_row -= midpoint_offset
      else
        l_row += midpoint_offset
      end
    end

    
    (7..9).each do |i|
      tot_cols_in_range = h_col - l_col + 1
      midpoint_offset = tot_cols_in_range / 2

      if seat[i] == "L"
        h_col -= midpoint_offset
      else
        l_col += midpoint_offset
      end
    end

    id = l_row * 8 + l_col
    booked.push(id)
  end

  booked_ordered = booked.sort

  (0..booked_ordered.size-2).each do |i|
    low = i
    high = i + 1

    if booked_ordered[high] - booked_ordered[low] == 2
      return booked_ordered[high] - 1 
    end
    
  end
 
  
end

file = "Inputs/day-05.txt"


seats = parse_input(file)

part_1 = solve_part_1(seats)
part_2 = solve_part_2(seats)

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"