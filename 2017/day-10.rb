# frozen_string_literal: true

def solve_part1(lengths)
  s    = (0...256).to_a
  cur  = 0
  skip = 0
  size = s.size

  lengths.each do |l|
    (0...(l / 2)).each do |i|
      a = (cur + i) % size
      b = (cur + l - 1 - i) % size
      s[a], s[b] = s[b], s[a]
    end

    cur = (cur + l + skip) % size
    skip += 1
  end

  s[0] * s[1]
end

def solve_part2(str)
  lengths = str.bytes + [17, 31, 73, 47, 23]
  s    = (0...256).to_a
  cur  = 0
  skip = 0
  size = s.size

  64.times do
    lengths.each do |l|
      (0...(l / 2)).each do |i|
        a = (cur + i) % size
        b = (cur + l - 1 - i) % size
        s[a], s[b] = s[b], s[a]
      end

      cur = (cur + l + skip) % size
      skip += 1
    end
  end

  # dense hash
  s.each_slice(16)
   .map { |block| block.reduce(:^).to_s(16).rjust(2, '0') }
   .join
end

lengths = '97,167,54,178,2,11,209,174,119,248,254,0,255,1,64,190'

puts "part 1: #{solve_part1(lengths.split(',').map(&:to_i))}"
puts "part 2: #{solve_part2(lengths)}"
