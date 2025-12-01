def solve_part_1(str)
  str = "ADVENT"
  #str = "A(1x5)BC"
  str = "A(2x2)BCD(2x2)EFG"
  #str = "(6x1)(1x3)A"
  str = "X(8x2)(3x3)ABCY"
  offset = 0
  prev = 0
 
  pattern = /\((\d+)x(\d+)\)/
  p str
  while md = pattern.match(str, offset)
    offset = md.begin(0)
    puts "offset: #{offset}"
 
    marker = "#{md[1]}x#{md[2]}".split("x").map {|i| i.to_i}
    p marker
    temp = str[md.end(0), marker[0]]
    str[md.begin(0), md.end(0) - md.begin(0)] = ""
   
    puts "temp: #{temp}"
    (marker[1]-1).times do |i|
      str.insert(offset, temp)
    end
    puts "string: #{str}"
    #p marker
    
    offset += marker[0] * marker[1]
    prev = offset

    break if offset >= str.length # Stop if we've reached or passed the end
  end
  #d_str += str[prev..str.size-1]
  puts str
  #puts "X(3x3)ABC(3x3)ABCY"
  str.length

end



def decompressed_length(str, i = 0, j = nil)
  j ||= str.length
  len = 0
  pattern = /\((\d+)x(\d+)\)/

  while i < j
    if str[i] != "("
      # Literal character
      len += 1
      i += 1
    else
      md = pattern.match(str, i)
      raise "bad marker" unless md

      chars = md[1].to_i
      times = md[2].to_i

      segment_start = md.end(0)
      segment_end   = segment_start + chars

      # Recursively compute the decompressed length of that segment
      seg_len = decompressed_length(str, segment_start, segment_end)

      len += times * seg_len
      i = segment_end
    end
  end

  len
end
def solve_part_2(str)
  decompressed_length(str.strip)
end

input = File.read("Inputs/day-09.txt")
# solve_part_1(input)
puts solve_part_2(input)




# def solve_part_1(str)
#   #str = "ADVENT"
#   #str = "A(1x5)BC"
#   #str = "A(2x2)BCD(2x2)EFG"
#   #str = "(6x1)(1x3)A"
#   #str = "X(8x2)(3x3)ABCY"
#   offset = 0
#   prev = 0
#   d_str = ""
#   pattern = /\((\d+)x(\d+)\)/
#   while md = pattern.match(str, offset)

#     #puts "prev: #{prev}, md.begin(0): #{md.begin(0)}"
#     #puts "#{str[prev,md.begin(0)-prev]}"
#     d_str += str[prev,md.begin(0)-prev]
 
#     marker = "#{md[1]}x#{md[2]}".split("x").map {|i| i.to_i}

#     temp = str[md.end(0), marker[0]]
#     #puts "temp: #{temp}"
#     marker[1].times do |i|
#       d_str += temp
#     end

#     #p marker
    
#     offset = md.end(0) + marker[0]
#     prev = offset

#     break if offset >= str.length # Stop if we've reached or passed the end
#   end
#   d_str += str[prev..str.size-1]
  
#   d_str.length

# end