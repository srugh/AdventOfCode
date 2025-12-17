# frozen_string_literal: true

require 'digest'
input = 'uqwqemis'

count = 3_231_920
md5 = Digest::MD5.new

array = Array.new(8, '*')

while array.count('*').positive?
  md5.reset
  str = input + count.to_s
  hex = md5.update str
  puts "count: #{count}" if (count % 100_000).zero?

  if hex.to_s.match(/\A0{5}/)
    index = -1
    pos = hex.to_s[5]
    case pos.to_s
    when '0'
      index = 0
    when '1'
      index = 1
    when '2'
      index = 2
    when '3'
      index = 3
    when '4'
      index = 4
    when '5'
      index = 5
    when '6'
      index = 6
    when '7'
      index = 7
    end
    if (index > -1) && (array[index] == '*')
      array[index] = hex.to_s[6]
      # puts "index: #{index} value: #{hex.to_s[6]}"
    end
  end
  count += 1
end

password = ''
array.each do |char|
  password += char
end

puts password
