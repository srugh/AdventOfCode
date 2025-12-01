require 'digest'

string = "ckczppom"
count = 1

hash_string = Digest::MD5.hexdigest(string + count.to_s)

while !hash_string.start_with?("000000")
    count += 1
    hash_string = Digest::MD5.hexdigest(string + count.to_s)
end

puts "count: #{count}"
puts "hash: #{hash_string}"

