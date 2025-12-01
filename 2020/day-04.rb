def parse_input(file)
    passports = []
    passport = Hash.new

    File.readlines(file, chomp:true).each do |line|
      if line == ""
        passports.push(passport)
        passport = Hash.new
        next
      end

      parts = line.split
      parts.each do |part|
        values = part.split(":")
        passport[values[0]] = values[1]
      end

    end

    passports.push(passport)

    passports
end

def solve_part_1(passports)
  required_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
  good = 0
  passports.each do |passport|
    valid = true
    required_fields.each do |field|
      if valid && !passport.key?(field)
        valid = false
      end
    end

    if valid 
      good += 1
    end
  end
  good
end

def solve_part_2(passports)
  required_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
  good = 0
  passports.each do |passport|
    valid = true
    required_fields.each do |field|
      if valid && !passport.key?(field)
        valid = false
      end
      if valid
        valid = check_value(field, passport[field])
      end
    end

    if valid 
      good += 1
    end
  end
  good

end

def check_value(key, value)

  eye_color_whitelist = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

  if value == nil
    return false
  end

  case key
  when "byr"
    value = value.to_i
    if value < 1920 || value > 2002
      return false
    end
  when "iyr"
    value = value.to_i
    if value < 2010 || value > 2020
      return false
    end
  when "eyr"
    value = value.to_i
    if value < 2020 || value > 2030
      return false
    end
  when "hgt"
    match_data = value.match(/(\d+)([A-Za-z]+)/)
    if !match_data
      return false
    end
    num = match_data[1].to_i
    text = match_data[2]

    if text == "cm"
      if num < 150 || num > 193
        return false
      end
    elsif text == "in"
      if num < 59 || num > 76
        return false
      end
    else
      return false
    end
  when "hcl"
    if value.size != 7 || value[0] != "#"
      return false
    end
    hex = value[1..6]
    if !hex.match?(/\A\h+\z/)
      return false
    end
  when "ecl"
    return eye_color_whitelist.include?(value)
  when "pid"
    if !value.match?(/\A\d+\Z/) || value.length != 9
      return false
    end
  end

  true
end

file = "Inputs/day-04.txt"

inputs = parse_input(file)

part_1 = solve_part_1(inputs)
part_2 = solve_part_2(inputs)

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"