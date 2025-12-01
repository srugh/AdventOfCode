require 'set'

def parse_input(input_file)
    desires = []
    parts = File.read(input_file).split("\n\n")

    options = parts[0].split(", ")
    
    parts[1].split("\n").each do |line|
        desires.push(line.chomp)
    end

    [options, desires]
end

def check_matches(options, desire)
    temp = []
    options.each do |option|
        contains = desire.match(option)
        if contains
            temp.push(option)
        end
    end

    puts "matches: #{temp.size} \t of #{options.size}"

    permutations = build_permutations(options, temp)

    permutations
end

def build_permutations(options, perms)
   
    max_size_of_perms = 3
    perm_strings = []

   
    
    max_size_of_perms.times.each_with_index do |idx|
        puts "Building perm: #{idx}"
        n_perms = perms.repeated_permutation(idx+1).to_a
        str = ""
        n_perms.each do |perm|
            str = ""
            perm.each do |towel|
                str += towel
            end
            perm_strings.push(str)
        end
        
    end
    puts perm_strings.size
    #p perms
    perm_strings
end

def count_ways_to_construct_design(available_patterns, design)
    # Dynamic programming table to store the number of ways
    dp = Array.new(design.length + 1, 0)
    dp[0] = 1 # Base case: 1 way to construct an empty design
  
    (1..design.length).each do |i|
        available_patterns.each do |pattern|
            len = pattern.length
            # Check if the pattern matches the end of the current substring
            if i >= len && design[i - len, len] == pattern
                dp[i] += dp[i - len]
            end
        end
    end
  
    dp[design.length] # Total number of ways to construct the full design
end

def can_construct_design(available_patterns, design)
        # Dynamic programming table to check constructability
        dp = Array.new(design.length + 1, false)
        dp[0] = true # Base case: empty design can always be constructed
    
        (1..design.length).each do |i|
        available_patterns.each do |pattern|
            len = pattern.length
            # Check if the pattern matches the end of the current substring
            if i >= len && design[i - len, len] == pattern
            dp[i] ||= dp[i - len]
            end
        end
        end
    
        dp[design.length] # Return whether the full design can be constructed
end

def calc_possibilities(options, desires)


    possible_count = 0
    results = []

    desires.each do |desire|
        count = count_ways_to_construct_design(options, desire)
        
        if count > 0
            possible_count += count
            results << "#{desire}: possible, #{count} ways"
        else
            results << "#{desire}: impossible"
        end

    end

    possible_count


 
end


input_file = "Inputs/sample.txt"
input_file = "Inputs/input.txt"

desires = []
options = []

options, desires = parse_input(input_file)
count = calc_possibilities(options, desires)

puts "Total possibilities: #{count}"

