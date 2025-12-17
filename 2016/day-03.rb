# frozen_string_literal: true

def parse_input(input_file)
  triangles = []
  File.readlines(input_file, chomp: true).each do |line|
    triangle = line.split
    triangles.push(triangle)
  end

  triangles
end

def process_triangles(triangles)
  possible = 0

  triangles_per_column = triangles.size / 3

  count = 0
  puts "Triangles per column:  #{triangles.size} / 3 = #{triangles_per_column}"
  triangles_per_column.times do
    tris = []
    tris.push([triangles[count][0].to_i, triangles[count + 1][0].to_i, triangles[count + 2][0].to_i])
    tris.push([triangles[count][1].to_i, triangles[count + 1][1].to_i, triangles[count + 2][1].to_i])
    tris.push([triangles[count][2].to_i, triangles[count + 1][2].to_i, triangles[count + 2][2].to_i])

    tris.each do |tri|
      p tri
      possible += 1 if tri[0] + tri[1] > tri[2] && tri[1] + tri[2] > tri[0] && tri[0] + tri[2] > tri[1]
    end

    count += 3
  end

  possible
end

input_file = 'Inputs/day-03-input.txt'

triangles = parse_input(input_file)
possible = process_triangles(triangles)

puts "Possible triangles: #{possible}"
