# frozen_string_literal: true

def parse_file(path)
  File.read(path).split(',')
end

def solve_part1(input)
  hash_total = 0
  input.each do |str|
    hash_val = 0
    str.bytes.each do |b|
      hash_val += b
      hash_val *= 17
      hash_val %= 256
    end
    hash_total += hash_val
  end
  hash_total
end

def solve_part2(input)
  boxes = Hash.new { |hash, key| hash[key] = {} }

  score = 0

  input.each do |str|
    box_id = 0
    label = ''
    focal_length = 0
    if str.include?('-')
      label = str.delete('-')
    elsif str.include?('=')
      label, focal_length = str.split('=')
    end

    label.bytes.each do |b|
      box_id += b
      box_id *= 17
      box_id %= 256
    end

    boxes[box_id].delete(label) if boxes[box_id].key?(label) && str.include?('-')
    boxes[box_id][label] = focal_length if str.include?('=')
  end

  p boxes
  boxes.each do |k, v|
    v.each_with_index do |(_label, val), idx|
      score += (k + 1) * (idx + 1) * val.to_i
    end
  end
  score
end

path = 'Inputs/day-15.txt'
input = parse_file(path)
puts "part 1: #{solve_part1(input)}"
puts "part 2: #{solve_part2(input)}"
