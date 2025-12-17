# frozen_string_literal: true

def solve_part1(bits)
  min_length = 35_651_584
  # bits = "1"
  # bits = "0"
  # bits = "11111"
  # bits = "111100001010"
  # bits = "10000"
  # min_length = 20
  # dragon curve
  while bits.length < min_length
    b = bits.reverse.tr('01', '10')       # reverse + flip bits
    bits = "#{bits}0#{b}"                 # allocate new, bigger string
  end

  bits = bits[0, min_length]
  puts 'check summing'
  # check sum
  checksum(bits)
end

def calc_checksum(bits)
  checksum = ''
  bits.chars.each_slice(2) do |pair|
    checksum += pair[0] == pair[1] ? '1' : '0'
  end
  checksum
end

def checksum(data)
  loop do
    out = +''
    i = 0
    len = data.length

    while i < len
      # faster than slicing: compare bytes directly
      c1 = data.getbyte(i)
      c2 = data.getbyte(i + 1)
      out << (c1 == c2 ? '1' : '0')
      i += 2
    end
    data = out
    break if data.length.odd?
  end

  data
end

input = '11100010111110100'

p solve_part1(input)
