# frozen_string_literal: true

def parse_input(path)
  File.read(path).chars.map(&:to_i)
end

def solve_part1(input)
  rows = 6
  cols = 25
  layer_size = rows * cols
  tot_layers = input.size / layer_size
  layers = Array.new(tot_layers, [])

  tot_layers.times do |layer|
    layers[layer] = input[(layer * layer_size)..((layer * layer_size) + layer_size - 1)]
  end

  fewest_0s = Float::INFINITY
  fewest_0s_layer = Float::INFINITY
  layers.each_with_index do |layer, i|
    if layer.count(0) < fewest_0s
      fewest_0s = layer.count(0)
      fewest_0s_layer = i
    end
  end
  layers[fewest_0s_layer].count(1) * layers[fewest_0s_layer].count(2)
end

def solve_part2(input)
  rows = 6
  cols = 25
  layer_size = rows * cols
  tot_layers = input.size / layer_size
  layers = Array.new(tot_layers, [])

  grid = Array.new(rows) { Array.new(cols) }

  tot_layers.times do |layer|
    layers[layer] = input[(layer * layer_size)..((layer * layer_size) + layer_size - 1)]
  end

  rows.times do |r|
    cols.times do |c|
      tot_layers.times do |l|
        next if layers[l][(r * cols) + c] == 2

        grid[r][c] = layers[l][(r * cols) + c]
        break
      end
    end
  end

  grid.each do |row|
    puts row.map { |p| p == 1 ? '#' : ' ' }.join
  end
end

path = 'Inputs/day-08.txt'
input = parse_input(path)
p_1 = solve_part1(input)
p_2 = solve_part2(input)

puts "p_1: #{p_1}"
puts "p_2: #{p_2}"
