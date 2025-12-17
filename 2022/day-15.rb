# frozen_string_literal: true

DIRS = [
  [0, 1],
  [0, -1],
  [1, 0],
  [-1, 0]
].freeze

def parse_input(path)
  hash = {}
  beacons = []
  File.readlines(path, chomp: true).each do |line|
    s_x, s_y, b_x, b_y = line.scan(/(-?\d+)/).flatten.map(&:to_i)
    hash[[s_x, s_y]] = (s_x - b_x).abs + (s_y - b_y).abs
    beacons << [b_x, b_y] unless beacons.include?([b_x, b_y])
  end
  [hash, beacons]
end

def solve_part1(sensor_distances, beacons)
  y_check = 10

  bs = beacons.select { |_, b| b == y_check }.map(&:first)
  bad_spots = Set.new
  sensor_distances.each do |(s_x, s_y), dist|
    next if ((s_y - y_check).abs - dist).positive?

    (0..dist).each do |x|
      adj_x = x + s_x
      if (s_x - adj_x).abs + (s_y - y_check).abs <= dist
        bad_spots.add(adj_x) unless bs.include?(adj_x)
        bad_spots.add(s_x - x) unless bs.include?(s_x - x)
      end
    end
  end

  bad_spots.size
end

def solve_part2(sensor_distances)
  # min, max = 0, 4_000_000
  _ = 0
  max = 20

  p sensor_distances
  (0..max).each do |y|
    (0..max).each do |x|
      sensor_fail = false
      sensor_distances.each do |(sx, sy), dist|
        puts "#{x}, #{sx}, #{y}, #{sy}"
        puts "#{(x - sx).abs + (y - sy).abs}, #{dist}"
        puts
        if (x - sx).abs + (y - sy).abs > dist
          sensor_fail = true
          break
        end
      end
      return (x * 4_000_000) + y unless sensor_fail
    end
  end
end

path = 'Inputs/day-15.txt'
distances, = parse_input(path)

# puts "part 1: #{solve_part1(distances, beacons)}"
puts "part 2: #{solve_part2(distances)}"
