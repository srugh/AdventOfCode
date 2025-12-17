# frozen_string_literal: true

# ordered to optimize "reading order" tie breaking
MOVES = [
  [-1, 0],
  [0, -1],
  [0, 1],
  [1, 0]
].freeze

def parse_input(path)
  File.read(path).split("\n").map(&:chars)
end

def initialize_game(grid)
  walls = Set.new
  units = Hash.new { |hash, key| hash[key] = {} }
  grid.each_with_index do |row, r|
    row.each_with_index do |col, c|
      case col
      when '#'
        walls.add([r, c])
      when 'G'
        id = units.size
        units[id]['location'] = [r, c]
        units[id]['health'] = 200
        units[id]['race'] = 'goblin'
      when 'E'
        id = units.size
        units[id]['location'] = [r, c]
        units[id]['health'] = 200
        units[id]['race'] = 'elf'
      end
    end
  end
  [walls, units]
end

def turn_order_for_round(units)
  units.sort_by do |_key, value|
    [value['location'].first, value['location'].last]
  end.map { |k, _v| k }
end

def move(unit_id, units, walls)
  unit = units[unit_id]
  start = unit['location']
  foe_locs = units.reject do |_id, data|
    data['race'] == unit['race']
  end.map { |_id, data| data['location'] }
  all_unit_locs = units.values.map { |data| data['location'] }
  all_unit_locs.delete(start)

  in_range_squares = Set.new
  foe_locs.each do |r, c|
    MOVES.each do |dr, dc|
      nr = r + dr
      nc = c + dc
      pos = [nr, nc]
      next if walls.include?(pos)
      next if all_unit_locs.include?(pos) # must be open

      in_range_squares.add(pos)
    end
  end

  moves = in_range_squares.map do |target|
    find_moves(start, target, all_unit_locs, walls)
  end

  shortest_path_size = Float::INFINITY
  shortest_index = -1
  moves.each_with_index do |move, idx|
    next if move.nil?

    if move.size < shortest_path_size
      shortest_path_size = move.size
      shortest_index = idx
    elsif move.size == shortest_path_size
      if move.last[0] < moves[shortest_index].last[0]
        shortest_index = idx
      elsif move.last[1] < moves[shortest_index].last[1] && move.last[0] == moves[shortest_index].last[0]
        shortest_index = idx
      end
    end
  end

  shortest_index >= 0 ? moves[shortest_index][1] : start
end

def find_moves(start_node, target_node, unit_locs, walls)
  queue = [[start_node, [start_node]]] # Queue stores [current_node, path_to_current_node]
  visited = Set.new([start_node])

  until queue.empty?
    current_node, path = queue.shift
    return path if current_node == target_node

    MOVES.each do |m_r, m_c|
      adj = [m_r + current_node[0], m_c + current_node[1]]
      next if unit_locs.include?(adj)
      next if walls.include?(adj)

      next if visited.include?(adj)

      visited.add(adj)
      new_path = path + [adj]
      queue << [adj, new_path]
    end
  end
  nil
end

def attack(target_id, units, elf_power = 3)
  unit = units[target_id]
  unit['health'] -= if unit['race'] == 'goblin'
                      elf_power
                    else
                      3
                    end
  units.delete(target_id) if unit['health'] <= 0
end

def choose_target(unit_id, units)
  target = nil
  unit = units[unit_id]
  foes = units.reject do |_id, data|
    data['race'] == unit['race']
  end
  u_r, u_c = unit['location']

  foes.each do |id, data|
    MOVES.each do |m_r, m_c|
      f_r, f_c = data['location']
      next unless f_r == m_r + u_r && f_c == m_c + u_c

      if target.nil? # first valid target
        target = [id, data['health'], f_r, f_c]
        next
      elsif data['health'] < target[1] # lower health priority
        target = [id, data['health'], f_r, f_c]
        next
      end

      if data['health'] == target[1]
        if f_r < target[2] # lower row priority
          target = [id, data['health'], f_r, f_c]
        elsif f_r == target[2] && f_c < target[3] # lower col priority
          target = [id, data['health'], f_r, f_c]
        end
      end
    end
  end
  target[0]
end

def can_attack?(unit_id, units)
  unit = units[unit_id]
  foe_locs = units.reject do |_id, data|
    data['race'] == unit['race']
  end.map { |_id, data| data['location'] }
  u_r, u_c = unit['location']

  MOVES.each do |m_r, m_c|
    return true if foe_locs.include?([u_r + m_r, u_c + m_c])
  end

  false
end

def game_over?(units)
  units.none? { |_id, data| data['race'] == 'elf' } ||
    units.none? { |_id, data| data['race'] == 'goblin' }
end

def solve_part1(grid)
  walls, units = initialize_game(grid)
  round = 0

  loop do
    turn_order_for_round(units).each do |unit_id|
      next unless units.key?(unit_id) # skip if unit was killed earlier in round
      return round * units.sum { |_id, data| data['health'] } if game_over?(units)

      # move, unless you can attack
      units[unit_id]['location'] = move(unit_id, units, walls) unless can_attack?(unit_id, units)

      # attack, if possible
      attack(choose_target(unit_id, units), units) if can_attack?(unit_id, units)
    end
    round += 1
  end
  puts 'you fucked up'
end

def play_game(elf_power, grid)
  walls, units = initialize_game(grid)
  round = 0
  starting_elves = units.count { |_id, data| data['race'] == 'elf' }

  loop do
    turn_order_for_round(units).each do |unit_id|
      next unless units.key?(unit_id) # skip if unit was killed earlier in round
      return [units, starting_elves, round * units.sum { |_id, data| data['health'] }] if game_over?(units)

      # move, unless you can attack
      units[unit_id]['location'] = move(unit_id, units, walls) unless can_attack?(unit_id, units)

      # attack, if possible
      attack(choose_target(unit_id, units), units, elf_power) if can_attack?(unit_id, units)
    end
    round += 1
  end
  puts 'you fucked up'
end

def attack(target_id, units, elf_power = 3)
  unit = units[target_id]
  unit['health'] -= if unit['race'] == 'goblin'
                      elf_power
                    else
                      3
                    end
  units.delete(target_id) if unit['health'] <= 0
end

def solve_part2(grid)
  max_power_with_loss = 3
  min_power_with_flawless_win = -1
  elf_power = max_power_with_loss * 10

  # history = {}
  sim_count = 0
  loop do
    puts "sims: #{sim_count}, elf_power: #{elf_power}, max_power_with_loss: #{max_power_with_loss}, min_power_win: #{min_power_with_flawless_win}"

    units, starting_elves, score = play_game(elf_power, grid)

    won = units.count { |_id, data| data['race'] == 'elf' } == starting_elves

    if won
      min_power_with_flawless_win = elf_power
      return score if min_power_with_flawless_win - max_power_with_loss == 1

      elf_power = (min_power_with_flawless_win + max_power_with_loss) / 2
      elf_power += 1 if (min_power_with_flawless_win + max_power_with_loss).odd?

    else
      max_power_with_loss = elf_power if elf_power > max_power_with_loss
      if min_power_with_flawless_win > -1
        elf_power = (min_power_with_flawless_win + max_power_with_loss) / 2
        elf_power += 1 if (min_power_with_flawless_win + max_power_with_loss).odd?
      else
        elf_power *= 2
      end
    end
    sim_count += 1
  end
end

# path = "Inputs/day-15-sample.txt"
path = 'Inputs/day-15.txt'
grid = parse_input(path)
# puts "part 1: #{solve_part1(grid)}"
puts "part 2: #{solve_part2(grid)}"
