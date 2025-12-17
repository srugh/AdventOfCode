# frozen_string_literal: true

def parse_input(input_file)
  parts = File.read(input_file).split("\n")

  times = parts[0].split
  times.shift

  records = parts[1].split
  records.shift

  [times.map(&:to_i), records.map(&:to_i)]
end

def calc_total(times, records)
  record_beaters = Array.new(times.size, 0)
  times.each_with_index do |time, idx|
    counter = 0
    while counter < time
      speed = counter

      record_beaters[idx] += 1 if speed * (time - counter) > records[idx]

      counter += 1
    end
  end
  record_beaters.inject(:*)
end

def calc_total_part_2(time, record)
  record_beaters = 0
  counter = 0
  while counter < time
    speed = counter

    record_beaters += 1 if speed * (time - counter) > record

    counter += 1

  end
  record_beaters
end

input_file = 'Inputs/day-06.txt'
# input_file = "Inputs/day-06-sample.txt"

times, records = parse_input(input_file)

time = 60_808_676
record = 601_116_315_591_300
part1_total = calc_total(times, records)
part2_total = calc_total_part_2(time, record)

puts "total part 1: #{part1_total}"
puts "total part 2: #{part2_total}"
