# frozen_string_literal: true

def parse_input(path)
  input = []
  File.read(path).split("\n").map { |l| l.scan(/(\w+)\W/) }.each do |line|
    checksum = line.pop[0]
    sector = line.pop[0].to_i
    str = ''
    line.each do |q|
      q.each do |r|
        str += r
      end
    end
    input.push([str, sector, checksum])
  end
  input
end

def solve_part1(input)
  part_1 = 0
  part_2 = ''
  input.each do |room|
    str, sector, checksum = room
    counts = {}
    str.chars.uniq.each do |c|
      counts[c] = str.count(c)
    end

    valid = true
    counts.sort_by { |key, value| [-value, key] }.to_h.each_with_index do |(k, _v), idx|
      break if idx > 4

      valid = false if k != checksum[idx]
    end

    next unless valid

    part_1 += sector
    shifted_text = ''
    str.each_char do |char|
      next unless char.match?(/[a-zA-Z]/) # Check if it's an alphabet character

      base = char.ord < 97 ? 'A'.ord : 'a'.ord # Determine base for uppercase or lowercase
      shifted_ord = ((char.ord - base + sector) % 26) + base
      shifted_text << shifted_ord.chr
    end
    part_2 = sector if shifted_text == 'northpoleobjectstorage'
  end
  [part_1, part_2]
end

path = 'Inputs/day-04.txt'
input = parse_input(path)
p solve_part1(input)
