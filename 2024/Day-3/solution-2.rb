require 'csv'



text = ""

mult_matches = []
enabled_mult_matches = []
mult_match_positions = []

do_matches=[]
do_match_positions = []

dont_matches = []
dont_match_positions = []

mult_regex = Regexp.new("mul\\(\\d{1,3},\\d{1,3}\\)") 
do_regex = Regexp.new("do\\(\\)")
dont_regex = Regexp.new("don\'t\\(\\)")

    File.foreach("../Inputs/input2.txt") do |line|
        #matches.push(line.scan(regex))
        text += line
    end

all_array = []    

mult_matches = text.scan(mult_regex) do |match|
  mult_match_positions.push(Regexp.last_match.begin(0))

  all_array[Regexp.last_match.begin(0)] = match
end

text.scan(do_regex) do
  do_match_positions.push(Regexp.last_match.begin(0))

  all_array[Regexp.last_match.begin(0)] = "enable"
end

text.scan(dont_regex) do
  dont_match_positions.push(Regexp.last_match.begin(0))

  all_array[Regexp.last_match.begin(0)] = "disable"
end

#puts mult_matches.size
#puts mult_match_positions.size
#puts do_match_positions.size
#puts dont_match_positions.size

mult_enabled = true

mult_pos = 0
do_pos = 0
dont_pos = 0



for i in 0..all_array.size-1
  unless all_array[i].nil?
    value = all_array[i]
    puts value
    if value != "enable" && value != "disable" && mult_enabled 
      enabled_mult_matches.push(mult_matches[all_array[i]])
    elsif value == "enable"
      mult_enabled = true
    elsif value == "disable"
      mult_enabled = false
    end
  end
end

puts enabled_mult_matches.size

total = 0
regexp2 = Regexp.new("\\d{1,3}")

enabled_mult_matches.each do |match|
  numbers = []
  numbers = match.scan(regexp2)
  total += numbers[0].to_i * numbers[1].to_i
end

  
puts total
