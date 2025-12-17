# frozen_string_literal: true

def parse_input(input_file)
  movement_string = ''
  parts = File.read(input_file).split("\n\n")

  grid = parts[0].split("\n").map do |line|
    line.chomp.chars
  end

  parts[1].split("\n").each do |line|
    movement_string += line.chomp
  end

  [grid, movement_string.chars]
end

def calc_boxes_gps_sum(grid, movements)
  double_grid = double_the_grid(grid)
  final_grid = process_movements(double_grid, movements)
  calc_boxes(final_grid)
end

def double_the_grid(grid)
  double_grid = []
  grid.each do |row|
    str = ''
    row.each do |col|
      case col
      when '#'
        str += '##'
      when '.'
        str += '..'
      when '@'
        str += '@.'
      when 'O'
        str += '[]'
      end
    end
    double_grid.push(str.chars)
  end
  double_grid
end

def calc_boxes(grid)
  total = 0
  grid.each_with_index do |row, r_idx|
    row.each_with_index do |col, c_idx|
      total += (100 * r_idx) + c_idx if col == '['
    end
  end
  total
end

def get_dir(movement)
  case movement
  when '^'
    [-1, 0]
  when 'v'
    [1, 0]
  when '<'
    [0, -1]
  when '>'
    [0, 1]
  else
    "You gave me #{x} -- I have no idea what to do with that."
  end
end

def process_movements(grid, movements)
  cur_pos = find_robot(grid)
  puts "Robot initial position: (#{cur_pos[0]}, #{cur_pos[1]})"
  puts 'Initial grid'
  pretty_print_grid(grid)

  movements.each_with_index do |movement, idx|
    puts "Grid after move #{idx + 1}:  (#{movement})"
    grid, cur_pos = attempt_move(grid, cur_pos, movement)

    puts "Grid after move #{idx + 1}:  (#{movement})"
    # pretty_print_grid(grid)
  end

  grid
end

def attempt_move(grid, cur_pos, movement)
  dir = get_dir(movement)
  next_pos = [cur_pos[0] + dir[0], cur_pos[1] + dir[1]]

  case grid[next_pos[0]][next_pos[1]]
  when '#'
    return [grid, cur_pos]
  when '[', ']'
    moveable, num_blocking_boxes, blocks = count_blocking_boxes(grid, cur_pos, dir, movement)
    if !moveable
      return [grid, cur_pos]
    elsif moveable
      case movement
      when '>'
        num_blocking_boxes.times.each do |box|
          next_col = (box * 2) + 2

          grid[cur_pos[0]][cur_pos[1] + next_col] = '['
          grid[cur_pos[0]][cur_pos[1] + next_col + 1] = ']'
        end
      when '<'
        num_blocking_boxes.times.each do |box|
          next_col = (box * 2) + 2

          grid[cur_pos[0]][cur_pos[1] - next_col] = ']'
          grid[cur_pos[0]][cur_pos[1] - next_col - 1] = '['
        end
      when 'v'
        blocks.each_with_index do |block, idx|
          if block[2] == '['
            grid[block[0] + 1][block[1]] = '['
            grid[block[0] + 1][block[1] + 1] = ']'

            grid[block[0]][block[1] + 1] = '.' if idx.zero?
          else
            grid[block[0] + 1][block[1]] = ']'
            grid[block[0] + 1][block[1] - 1] = '['

            grid[block[0]][block[1] - 1] = '.' if idx.zero?

          end
          # pretty_print_grid(grid)
        end
      when '^'
        blocks.each_with_index do |block, idx|
          if block[2] == '['
            grid[block[0] - 1][block[1]] = '['
            grid[block[0] - 1][block[1] + 1] = ']'

            grid[block[0]][block[1] + 1] = '.' if idx.zero?
          else
            grid[block[0] - 1][block[1]] = ']'
            grid[block[0] - 1][block[1] - 1] = '['

            grid[block[0]][block[1] - 1] = '.' if idx.zero?

          end
          # pretty_print_grid(grid)
        end

      end

      grid[cur_pos[0]][cur_pos[1]] = '.'
      grid[next_pos[0]][next_pos[1]] = '@'
      if ['^', 'v'].include?(movement)
        # pretty_print_grid(grid)
      end
      return [grid, next_pos]
    end
  when '.'
    grid[cur_pos[0]][cur_pos[1]] = '.'
    grid[next_pos[0]][next_pos[1]] = '@'
    return [grid, next_pos]
  end

  puts 'something went wrong'
end

def count_blocking_boxes(grid, cur_pos, dir, movement)
  count = 0

  blocks = []
  loop do
    next_pos = [cur_pos[0] + dir[0], cur_pos[1] + dir[1]]

    if ['<', '>'].include?(movement)

      case grid[next_pos[0]][next_pos[1]]
      when '[', ']'
        count += 1
        blocks.push([next_pos[0], next_pos[1], grid[next_pos[0]][next_pos[1]]])
        cur_pos = next_pos
      when '.'
        return true, count / 2, blocks
      when '#'
        return false, count, blocks
      end

    else
      case grid[next_pos[0]][next_pos[1]]
      when '[', ']'
        count += 1
        blocks.push([next_pos[0], next_pos[1], grid[next_pos[0]][next_pos[1]]])
        cur_pos = next_pos
      when '.'
        return true, count, blocks if grid[cur_pos[0]][cur_pos[1]] == '[' && grid[next_pos[0]][next_pos[1] + 1] == '.'
        return true, count, blocks if grid[cur_pos[0]][cur_pos[1]] == ']' && grid[next_pos[0]][next_pos[1] - 1] == '.'

        return false, count, blocks
      when '#'
        return false, count, blocks
      end

    end
  end
end

def find_robot(grid)
  grid.each_with_index do |row, r_idx|
    row.each_with_index do |col, c_idx|
      return [r_idx, c_idx] if col == '@'
    end
  end
end

def pretty_print_grid(grid)
  grid.each do |row|
    row.each do |col|
      print col
    end
    print "\n"
  end
  print "\n"
end
input_file = 'Inputs/input.txt'

grid, movements = parse_input(input_file)
boxes_gps_sum = calc_boxes_gps_sum(grid, movements)

puts "boxes gps sum: #{boxes_gps_sum}"
