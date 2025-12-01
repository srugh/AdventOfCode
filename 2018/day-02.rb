require 'set'
doubles = 0
triples = 0
ids = []
File.readlines("Inputs/day-02.txt", chomp: true).each do |line|
    char_counts = Hash.new
    ids.push(line)
    line.each_char do |c|
        if char_counts.key?(c)
            char_counts[c] += 1
        else
            char_counts[c] = 1
        end
    end
    doubles += 1 if char_counts.has_value?(2)
    triples += 1 if char_counts.has_value?(3)
end

puts "part_1: #{doubles * triples}"

ids.each do |id_1|
    ids.each do |id_2|
        misses = 0
        miss_idx = 0
        next if id_1 == id_2
        id_1.length.times do |idx|
            
            if id_1[idx] != id_2[idx]
                misses += 1
                miss_idx = idx
            end
        end
        if misses <= 1
            id = id_2
            id[miss_idx] = ""
            puts "part_2: #{id}"
        end
    end
end