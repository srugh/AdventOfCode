def parse_file(path)
  mappings = Hash.new
  str, maps = File.read(path).split(/\n\n/).map{|chunk| chunk.split(/\n/)}
  maps.each do |map|
    match_str, split_char = map.split(" -> ")
    mappings[match_str] = split_char
  end

  [str[0], mappings]
end

def solve_part_1(str, mappings)
  cur_str = ""
  40.times do |i|
    puts i
    cur_str = ""
    (str.length-1).times do |offset|
      cur_str += str[offset] + mappings[str[offset,2]]
    end
    str = cur_str + str[str.length-1]
  end

  max_char = -Float::INFINITY
  min_char = Float::INFINITY
  str.chars.uniq.each do |c|
    count = str.count(c)
    max_char = count if count > max_char
    min_char = count if count < min_char
  end

  max_char - min_char
end

path = "Inputs/day-14.txt"
starting_str, mappings = parse_file(path)
puts "part_1: #{solve_part_1(starting_str, mappings)}"