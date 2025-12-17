# frozen_string_literal: true

def populate_grid(input_file)
  grid = []
  File.foreach(input_file) do |line|
    grid << line.chomp.chars
  end

  grid
end

def calc_total_antinodes(grid)
  antennas = find_all_antennas(grid)

  antinodes = Set.new
  antennas.each do |key, locations|
    puts "Processing points for key '#{key}'"
    if locations.size >= 2
      locations.each do |location|
        antinodes << location
      end
    end
    # Iterate through every pair of points
    locations.combination(2).each do |loc1, loc2|
      row_slope = loc1[0] - loc2[0]
      col_slope = loc2[1] - loc1[1]
      slope = row_slope.to_f / col_slope

      # puts "#{loc1} - #{loc2}:  row_slope: #{row_slope}  col_slope: #{col_slope} slope: #{slope}"

      if slope.positive?
        antinode_between_row = loc1[0] - row_slope
        antinode_between_col = loc1[1] + col_slope

        antinodes << [antinode_between_row, antinode_between_col]

        antinode1_row = loc1[0] - row_slope.abs
        antinode1_col = loc1[1] - col_slope

        antinode2_row = loc2[0] - row_slope
        antinode2_col = loc2[1] - col_slope.abs

        while antinode1_row >= 0 && antinode1_row < grid.size && antinode1_col >= 0 && antinode1_col < grid[0].size
          puts "#{loc1}, #{loc2}: (#{antinode1_row},#{antinode1_col})"
          antinodes << [antinode1_row, antinode1_col]
          antinode1_row -= row_slope.abs
          antinode1_col -= col_slope
        end

        while antinode2_row >= 0 && antinode2_row < grid.size && antinode2_col >= 0 && antinode2_col < grid[0].size
          puts "#{loc1}, #{loc2}: (#{antinode2_row},#{antinode2_col})"
          antinodes << [antinode2_row, antinode2_col]
          antinode2_row -= row_slope
          antinode2_col -= col_slope.abs
        end

      # puts "(#{loc1[0]},#{loc1[1]}), (#{loc2[0]},#{loc2[1]}): (#{antinode1_row},#{antinode1_col}), (#{antinode2_row},#{antinode2_col})"
      # puts "(#{loc1[0]},#{loc1[1]}), (#{loc2[0]},#{loc2[1]}): "
      elsif slope.negative?
        antinode_between_row = loc1[0] - row_slope
        antinode_between_col = loc1[1] + col_slope

        antinodes << [antinode_between_row, antinode_between_col]
        antinode1_row = loc1[0] + row_slope
        antinode1_col = loc1[1] - col_slope
        antinode2_row = loc2[0] - row_slope
        antinode2_col = loc2[1] + col_slope

        while antinode1_row >= 0 && antinode1_row < grid.size && antinode1_col >= 0 && antinode1_col < grid[0].size
          puts "#{loc1}, #{loc2}: (#{antinode1_row},#{antinode1_col})"
          antinodes << [antinode1_row, antinode1_col]
          antinode1_row += row_slope
          antinode1_col -= col_slope
        end

        while antinode2_row >= 0 && antinode2_row < grid.size && antinode2_col >= 0 && antinode2_col < grid[0].size
          puts "#{loc1}, #{loc2}: (#{antinode2_row},#{antinode2_col})"
          antinodes << [antinode2_row, antinode2_col]
          antinode2_row -= row_slope
          antinode2_col += col_slope
        end
      else
        puts 'NOT HANDLED'
      end
    end
  end

  puts '---'
  # p antinodes
  grid2 = grid
  antinodes.each do |node|
    grid2[node[0]][node[1]] = '#'
  end
  grid2.each do |row|
    (0..row.size).each do |i|
      print row[i]
    end
    print "\n"
  end
  antinodes.size
end

def find_all_antennas(grid)
  antennas = Hash.new { |hash, key| hash[key] = [] }

  grid.each_with_index do |row, row_idx|
    row.select.each_with_index do |val, col_idx|
      antennas[val] << [row_idx, col_idx] if val != '#' && val != '.'
    end
  end

  antennas
end

input_file = 'Inputs/input1.txt'
# input_file = "Inputs/sample.txt"
grid = populate_grid(input_file)

total_antinodes = calc_total_antinodes(grid)

puts "total antenodes: #{total_antinodes}"
