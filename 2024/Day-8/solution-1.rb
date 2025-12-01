require 'set'

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
      
        # Iterate through every pair of points
        locations.combination(2).each do |loc1, loc2|
            row_slope = loc1[0] - loc2[0]
            col_slope = loc2[1] - loc1[1]
            slope = row_slope.to_f / col_slope

            #puts "#{loc1} - #{loc2}:  row_slope: #{row_slope}  col_slope: #{col_slope} slope: #{slope}"

            if slope > 0
                antinode1_row = loc1[0] - row_slope.abs
                antinode1_col = loc1[1] - col_slope
                antinode2_row = loc2[0] - row_slope
                antinode2_col = loc2[1] - col_slope.abs
                
                if(antinode1_row >= 0 && antinode1_row < grid.size && antinode1_col >= 0 && antinode1_col < grid[0].size )
                    puts "#{loc1}, #{loc2}: (#{antinode1_row},#{antinode1_col})"
                    antinodes << [antinode1_row, antinode1_col]
                end
                if(antinode2_row >= 0 && antinode2_row < grid.size && antinode2_col >= 0 && antinode2_col < grid[0].size )
                    puts "#{loc1}, #{loc2}: (#{antinode2_row},#{antinode2_col})"
                    antinodes << [antinode2_row, antinode2_col]
                end

                #puts "(#{loc1[0]},#{loc1[1]}), (#{loc2[0]},#{loc2[1]}): (#{antinode1_row},#{antinode1_col}), (#{antinode2_row},#{antinode2_col})"
                #puts "(#{loc1[0]},#{loc1[1]}), (#{loc2[0]},#{loc2[1]}): "
            elsif slope < 0
                antinode1_row = loc1[0] + row_slope
                antinode1_col = loc1[1] - col_slope
                antinode2_row = loc2[0] - row_slope
                antinode2_col = loc2[1] + col_slope.abs
                
                if(antinode1_row >= 0 && antinode1_row < grid.size && antinode1_col >= 0 && antinode1_col < grid[0].size )
                    puts "#{loc1}, #{loc2}: (#{antinode1_row},#{antinode1_col})"
                    antinodes << [antinode1_row, antinode1_col]
                end
                if(antinode2_row >= 0 && antinode2_row < grid.size && antinode2_col >= 0 && antinode2_col < grid[0].size )
                    puts "#{loc1}, #{loc2}: (#{antinode2_row},#{antinode2_col})"
                    antinodes << [antinode2_row, antinode2_col]
                end
            else
                puts "NOT HANDLED"
            end
        end
    end
    antinodes.size
end

def find_all_antennas(grid)
    antennas = Hash.new { |hash, key| hash[key] = [] }

    grid.each_with_index do |row, row_idx|
        row.select.each_with_index do |val, col_idx| 
            if val != "#" && val != "."
                antennas[val] << [row_idx, col_idx]
            end
        end
    end

    antennas
end

input_file = "Inputs/input1.txt"
#input_file = "Inputs/sample.txt"
total_antinodes = 0
grid = populate_grid(input_file)

total_antinodes = calc_total_antinodes(grid)

puts "total antenodes: #{total_antinodes}"
