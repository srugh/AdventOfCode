require 'csv'


regex = Regexp.new("mul\\(\\d{1,3},\\d{1,3}\\)") 
text = ""
matches=[]

    File.foreach("../Inputs/input.txt") do |line|

        text += line
    end

    

matches = text.scan(regex)
puts matches.size
total = 0
regexp2 = Regexp.new("\\d{1,3}")

matches.each do |match|
  numbers = []

    numbers = match.scan(regexp2)
    total += numbers[0].to_i * numbers[1].to_i

end
puts total