# frozen_string_literal: true

def parse_input(input)
  locks = []
  keys = []
  parts = File.read(input).split("\n\n")
  parts.each do |part|
    rows = part.split("\n")
    if rows[0] == '#####'
      locks.push(rows)
    elsif rows[0] == '.....'
      keys.push(rows)
    end
  end
  [locks, keys]
end

def convert_schematic(schematics, _type)
  num_schematics = []
  schematics.each do |schematic|
    num_rep = [0, 0, 0, 0, 0]
    schematic.each do |row|
      row.each_char.with_index do |char, idx|
        num_rep[idx] += 1 if char == '#'
      end
    end
    num_schematics.push(num_rep)
  end
  num_schematics
end

def key_fits?(lock, key)
  overlap_detected = false
  lock.size.times do |idx|
    overlap_detected = true unless lock[idx] + key[idx] <= 7
  end
  !overlap_detected
end

def check_combos(locks, keys)
  potential_combos = 0
  locks_num = convert_schematic(locks, 'locks')
  keys_num = convert_schematic(keys, 'keys')
  p locks_num
  p keys_num

  locks_num.each do |lock|
    keys_num.each do |key|
      potential_combos += 1 if key_fits?(lock, key)
    end
  end

  potential_combos
end
file = 'Inputs/input.txt'

locks, keys = parse_input(file)
potential_keys = check_combos(locks, keys)

p locks
p keys
puts "total non-overlapping: #{potential_keys}"
