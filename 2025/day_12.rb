# frozen_string_literal: true

def parse_input(path)
  shapes = []
  trees = []
  parts = File.read(path).split("\n\n")

  parts[0...(parts.size - 1)].each do |part|
    lines = part.split("\n")
    shape = []
    lines[1..].each_with_index do |line, r|
      line.chars.each_with_index do |ch, c|
        shape << [r, c] if ch == '#'
      end
    end
    shapes << shape
  end

  parts.last.split("\n").each do |line|
    l, r = line.split(':')
    trees << [l.split('x').map(&:to_i), r.split.map(&:to_i)]
  end

  [shapes, trees]
end

def solve_part1(shapes, trees)
  shape_areas = shapes.map(&:size)
  count = 0
  trees.each do |(width, height), inventory|
    t_area = width * height
    p_area = 0
    inventory.each_with_index do |inv, i|
      p_area += inv * shape_areas[i]
    end
    count += 1 if t_area > p_area
  end
  count
end

path = 'Inputs/day-12.txt'
shapes, trees = parse_input(path)
puts "part 1: #{solve_part1(shapes, trees)}"
