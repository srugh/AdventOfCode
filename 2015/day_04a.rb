# frozen_string_literal: true

require 'digest'

string = 'ckczppom'
count = 1

hash_string = Digest::MD5.hexdigest(string + count.to_s)

until hash_string.start_with?('00000')
  count += 1
  hash_string = Digest::MD5.hexdigest(string + count.to_s)
end

puts "count: #{count}"
puts "hash: #{hash_string}"
