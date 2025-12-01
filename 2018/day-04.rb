require 'set'

def parse_file(input)
    time_hash = Hash.new
    time_arr = []

    File.readlines(input, chomp:true).each do |line|
        parts = line.split(" ")
        time_hash[parts[0] + " " + parts[1]] = [parts[2], parts[3]]
        time_arr.push(parts[0] + " " + parts[1])
    end

    [time_hash, time_arr]
end

def process_data(time_hash, time_arr)
    part_1 = 0
    guard = ""
    guards = Hash.new
    sleep_start = 0
    sleep_end = 0
    time_arr.sort.each do |time|
        
        mins = (time[15] + time[16]).to_i
 
        if time_hash[time][0] == "Guard"
            guard = time_hash[time][1]
        elsif time_hash[time][0] == "falls"
            sleep_start = mins

        elsif time_hash[time][0] == "wakes"
            sleep_end = mins - 1
            
            if guards.key?(guard)
                guards[guard].push([sleep_start, sleep_end])
            else
                guards[guard] = [[sleep_start, sleep_end]]
            end
        end
    end

    max_sleep = ["", 0]
    guards.each do |g|
        asleep = 0
        g[1].each do |range|
            asleep += range[1] - range[0]
        end
        if asleep > max_sleep[1]
            max_sleep[0] = g[0]
            max_sleep[1] = asleep
        end
    end

    guards_per_minute = []
    guards.each do |g|
        sleep_mins = Array.new(60, 0)
        g[1].each do |range|
            
            for i in range[0]..range[1]
                sleep_mins[i] += 1
            end
        end 
        guards_per_minute.push([g[0], sleep_mins.index(sleep_mins.max), sleep_mins.max])
    end

    p guards_per_minute
    
    g_id = (max_sleep[0][1] + max_sleep[0][2] + max_sleep[0][3] + max_sleep[0][4]).to_i
    puts g_id
    puts sleep_mins.index(sleep_mins.max)
    part_1 = g_id * sleep_mins.index(sleep_mins.max)

    part_1
end

input = "Inputs/day-04.txt"

time_hash, time_arr = parse_file(input)
part_1 = process_data(time_hash, time_arr)
puts "part_1: #{part_1}"
