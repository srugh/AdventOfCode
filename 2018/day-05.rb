
def remove_unit(str, unit)
    str.gsub!(/#{unit}/, '')
    str.gsub!(/#{unit.upcase}/, '')
    str
end

def react(str)
    chars = ('a'..'z').to_a
    loop do
        len = str.length
        chars.each do |c|
            regx = c + c.upcase
            regx_2 = c.upcase + c

            str.gsub!(/#{regx}/, '')
        
            str.gsub!(/#{regx_2}/, '')    
        end

        break unless len > str.length 
    end

    puts "length: #{str.length}"
    
    str.length
end



str = File.read("Inputs/day-05.txt")
shortest = 100_000_000
chars = ('a'..'z').to_a

chars.each do |c|
    s = str.dup
    puts c
    puts s.length
    s = remove_unit(s, c)
    puts s.length
    x = react(s)
    if x < shortest
        shortest = x
    end
end

puts "part_2: #{shortest}"