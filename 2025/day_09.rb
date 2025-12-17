# frozen_string_literal: true

def parse_input(path)
  File.readlines(path, chomp: true).map { |l| l.split(',').map(&:to_i) }
end

def solve_part1(red_coords)
  area_calc = lambda do |a, b|
    ((a[0] - b[0]).abs + 1) * ((a[1] - b[1]).abs + 1)
  end
  largest_area = -Float::INFINITY
  red_coords.each_with_index do |a, i|
    red_coords[(i + 1)...red_coords.size].each do |b|
      largest_area = area_calc.call(a, b) if area_calc.call(a, b) > largest_area
    end
  end
  largest_area
end

def solve_part2(red_coords)
  area_calc = lambda do |a, b|
    ((a[0] - b[0]).abs + 1) * ((a[1] - b[1]).abs + 1)
  end

  pairs = []
  red_coords.each_with_index do |a, i|
    red_coords[(i + 1)...red_coords.size].each do |b|
      pairs << [area_calc.call(a, b), a, b]
    end
  end

  pairs.sort_by! { |(ar, _a, _b)| -ar }

  sides = red_coords.each_with_index.map do |p, i|
    q = red_coords[(i + 1) % red_coords.size]
    [p, q]
  end

  in_range = lambda do |a1, a2, b1, b2|
    !(
      (a1 <= b1 && a1 <= b2 && a2 <= b1 && a2 <= b2) ||
      (a1 >= b1 && a1 >= b2 && a2 >= b1 && a2 >= b2)
    )
  end

  intersect_sides = lambda do |a, b|
    x1, y1 = a
    x2, y2 = b
    sides.any? do |(sx1, sy1), (sx2, sy2)|
      in_range.call(sy1, sy2, y1, y2) &&
        in_range.call(sx1, sx2, x1, x2)
    end
  end

  best = pairs.find do |_ar, a, b|
    !intersect_sides.call(a, b)
  end

  best[0]
end

path = 'Inputs/day-09.txt'
points = parse_input(path)
puts "part 1: #{solve_part1(points)}"
puts "part 2: #{solve_part2(points)}"
