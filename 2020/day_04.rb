# frozen_string_literal: true

def parse_input(file)
  passports = []
  passport = {}

  File.readlines(file, chomp: true).each do |line|
    if line == ''
      passports.push(passport)
      passport = {}
      next
    end

    parts = line.split
    parts.each do |part|
      values = part.split(':')
      passport[values[0]] = values[1]
    end
  end

  passports.push(passport)

  passports
end

def solve_part1(passports)
  required_fields = %w[byr iyr eyr hgt hcl ecl pid]
  good = 0
  passports.each do |passport|
    valid = true
    required_fields.each do |field|
      valid = false if valid && !passport.key?(field)
    end

    good += 1 if valid
  end
  good
end

def solve_part2(passports)
  required_fields = %w[byr iyr eyr hgt hcl ecl pid]
  good = 0
  passports.each do |passport|
    valid = true
    required_fields.each do |field|
      valid = false if valid && !passport.key?(field)
      valid = check_value(field, passport[field]) if valid
    end

    good += 1 if valid
  end
  good
end

def check_value(key, value)
  eye_color_whitelist = %w[amb blu brn gry grn hzl oth]

  return false if value.nil?

  case key
  when 'byr'
    value = value.to_i
    return false if value < 1920 || value > 2002
  when 'iyr'
    value = value.to_i
    return false if value < 2010 || value > 2020
  when 'eyr'
    value = value.to_i
    return false if value < 2020 || value > 2030
  when 'hgt'
    match_data = value.match(/(\d+)([A-Za-z]+)/)
    return false unless match_data

    num = match_data[1].to_i
    text = match_data[2]

    if text == 'cm'
      return false if num < 150 || num > 193
    elsif text == 'in'
      return false if num < 59 || num > 76
    else
      return false
    end
  when 'hcl'
    return false if value.size != 7 || value[0] != '#'

    hex = value[1..6]
    return false unless hex.match?(/\A\h+\z/)
  when 'ecl'
    return eye_color_whitelist.include?(value)
  when 'pid'
    return false if !value.match?(/\A\d+\Z/) || value.length != 9
  end

  true
end

file = 'Inputs/day-04.txt'

inputs = parse_input(file)

part_1 = solve_part1(inputs)
part_2 = solve_part2(inputs)

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"
