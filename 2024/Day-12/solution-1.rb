# frozen_string_literal: true

def populate_grid(input_file)
  grid = []
  File.foreach(input_file) do |line|
    grid << line.chomp.chars
  end

  grid
end

def find_total_fence_price(grid)
  regions = find_regions(grid)
  # p regions
  calc_fencing(regions, grid)
end

def find_regions(grid)
  plot_in_a_region = Set.new
  # regions = []
  region_count = 0
  regions = Hash.new { |hash, key| hash[key] = [] }

  directions = [[0, 1], [0, -1], [1, 0], [-1, 0]]

  grid.each_with_index do |row, row_idx|
    row.each_with_index do |plot, col_idx|
      next if plot_in_a_region.include?([row_idx, col_idx])

      visited = Set.new
      queue = [[row_idx, col_idx]]
      plot_in_a_region.add([row_idx, col_idx])
      region_count += 1 unless col_idx.zero? && row_idx.zero?
      regions[region_count].push([row_idx, col_idx])

      until queue.empty?
        cur_pos = queue.shift
        visited.add(cur_pos)

        directions.each do |dir|
          next_pos = [cur_pos[0] + dir[0], cur_pos[1] + dir[1]]

          next unless is_valid?(plot, cur_pos, next_pos, plot_in_a_region,
                                grid) && !visited.include?(next_pos)

          queue << next_pos
          visited.add(next_pos)
          regions[region_count].push(next_pos)
          plot_in_a_region.add(next_pos)
        end
      end
      # break
    end
  end
  regions
end

def is_valid?(_plot, cur_pos, next_pos, plot_in_a_region, grid)
  # puts "start check is_valid: plot: #{plot} \t cur: #{cur_pos} \t next: #{next_pos} "
  within_bounds = next_pos[0].between?(0, grid.size - 1) &&
                  next_pos[1].between?(0, grid[0].size - 1)

  same_value = within_bounds &&
               grid[next_pos[0]][next_pos[1]] == grid[cur_pos[0]][cur_pos[1]]

  not_already_in_region = !plot_in_a_region.include?(next_pos)
  # puts "check: #{within_bounds && same_value && not_already_in_region}: bound: #{within_bounds} \t same: #{same_value} \t not_included: #{not_already_in_region} "
  within_bounds && same_value && not_already_in_region
end

def calc_border(cur_pos, next_pos, grid)
  within_bounds = next_pos[0].between?(0, grid.size - 1) &&
                  next_pos[1].between?(0, grid[0].size - 1)

  in_region = within_bounds && grid[next_pos[0]][next_pos[1]] == grid[cur_pos[0]][cur_pos[1]]

  has_border = !within_bounds || !in_region

  return 1 if has_border

  0
end

def calc_fencing(regions, grid)
  directions = [[0, 1], [0, -1], [1, 0], [-1, 0]]
  total_cost = 0
  p regions
  regions.each do |region|
    area = region[1].size
    borders = 0
    region[1].each do |cur_pos|
      directions.each do |dir|
        next_pos = [cur_pos[0] + dir[0], cur_pos[1] + dir[1]]
        borders += calc_border(cur_pos, next_pos, grid)
      end
    end
    puts "region #{region[0]}: area: #{area} borders: #{borders} price: #{area * borders}"
    total_cost += area * borders
  end
  total_cost
end

input_file = 'Inputs/small_sample.txt'
# input_file = "Inputs/sample.txt"
# input_file = "Inputs/input1.txt"

grid = populate_grid(input_file)
total_fence_price = find_total_fence_price(grid)

puts "Total price of fencing is: #{total_fence_price}"
