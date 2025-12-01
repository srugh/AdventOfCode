require 'set'

frequency = 0
freq_set = Set.new
deltas = []
run = 0

freq_set.add(frequency)

File.readlines("Inputs/day-01.txt").each do |line|
    deltas.push(line.chomp.to_i)
end

while run >= 0
    run += 1
    deltas.each do |delta|
        frequency += delta
        if freq_set.include?(frequency)
            puts "part_2: #{frequency}"
            run = -1
            break
        end
        freq_set.add(frequency)
    end
    if run == 1
        puts "part_1: #{frequency}"
    end
end


