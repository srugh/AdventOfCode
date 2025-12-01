def parse_input(file)
    nums = []
    File.readlines(file, chomp:true).each do |line|
        nums.push(line.to_i)
    end

    nums
end

def solve_part_1(nums)
    nums.sort!

    (nums.size).times.each_with_index do |idx|
        (nums.size).times.each_with_index do |idy|
            (nums.size).times.each_with_index do |idz|
           
                if nums[idx] + nums[idy] + nums[idz] == 2020
                    puts nums[idx]
                    puts nums[idy]
                    puts nums[idz]
                    return nums[idx] * nums[idy] * nums[idz]
                end
            end
        end
    end

end

input = "Inputs/day-01.txt"

nums = []

nums = parse_input(input)

part_1 = solve_part_1(nums)

puts "part 1: #{part_1}"