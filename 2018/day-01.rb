# frozen_string_literal: true

frequency = 0
freq_set = Set.new
run = 0

freq_set.add(frequency)

deltas = File.readlines('Inputs/day-01.txt').map do |line|
  line.chomp.to_i
end

while run >= 0
  run += 1
  deltas.each do |delta|
    frequency += delta
    if freq_set.include?(frequency)
      puts "part_2: #{frequency}"
      run = -1
      break
    end
    freq_set.add(frequency)
  end
  puts "part_1: #{frequency}" if run == 1
end
