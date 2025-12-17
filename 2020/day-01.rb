# frozen_string_literal: true

def parse_input(file)
  File.readlines(file, chomp: true).map(&:to_i)
end

def solve_part1(nums)
  nums.sort!

  nums.size.times.each do |idx|
    nums.size.times.each do |idy|
      nums.size.times.each do |idz|
        next unless nums[idx] + nums[idy] + nums[idz] == 2020

        puts nums[idx]
        puts nums[idy]
        puts nums[idz]
        return nums[idx] * nums[idy] * nums[idz]
      end
    end
  end
end

input = 'Inputs/day-01.txt'

nums = parse_input(input)

part_1 = solve_part1(nums)

puts "part 1: #{part_1}"
