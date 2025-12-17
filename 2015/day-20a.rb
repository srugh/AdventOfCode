# frozen_string_literal: true

count = 700_000

loop do
  gifts = 0
  count.times.each do |idx|
    gifts += (idx + 1) * 10 if (count % (idx + 1)).zero?
  end
  puts "house: #{count} \t gifts: #{gifts}"
  count += 1
  break unless gifts < 29_000_000 || count == 665_280
end
