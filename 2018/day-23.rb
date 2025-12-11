def parse_input(path)
  nbs = {}
  File.readlines(path, chomp: true).each do |line|
    x, y, z, r = line.scan(/(-?\d+)/).flatten.map(&:to_i)
    nbs[[x,y,z]] = r
  end
  nbs
end

def solve_part_1(nanobots)
  key, r = nanobots.max_by { |key, value| value }
  x,y,z = key

  count = 0
  nanobots.each do |(dx, dy, dz), _v|
    count = count + 1 if (x-dx).abs + (y-dy).abs + (z-dz).abs <= r
  end
  count
end

def solve_part_2(nanobots)
  inrange = Hash.new { |hash, key| hash[key] = []}

  nanobots.each do |main, r|
    x, y, z = main
    count = 0
    nanobots.each do |(dx,dy,dz), _v|
      next if main == [dx,dy,dz]
      count = count + 1 if (x-dx).abs + (y-dy).abs + (z-dz).abs <= r
    end
    inrange[count] << main
  end

  p inrange
  m_dist = Float::INFINITY
  inrange[inrange.keys.max].each do |k|
    m_dist = k.sum if k.sum < m_dist

  end
  m_dist
end

path = "Inputs/day-23.txt"
nbs = parse_input(path)
puts "part 1: #{solve_part_1(nbs)}"
puts "part 2: #{solve_part_2(nbs)}"