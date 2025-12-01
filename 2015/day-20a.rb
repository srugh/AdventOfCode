
count = 700_000


loop do
    gifts = 0
    count.times.each_with_index do |idx|
        if count % (idx + 1) == 0
            gifts += (idx + 1) * 10
        end
        
    end
    puts "house: #{count} \t gifts: #{gifts}"
    count += 1
    break unless gifts < 29000000 || count == 665280
end

