# frozen_string_literal: true

def parse_input(path)
  lines = File.readlines(path, chomp: true)
  circuits = {}

  lines.each do |line|
    l, r = line.split(' -> ')
    circuits[r] = l.split
  end

  circuits
end

def solve_part1(circuits)
  mask_16_bit = 0xFFFF

  commands = {
    'NOT' => ->(value) { (~value) & mask_16_bit },
    'AND' => ->(value1, value2) { value1 & value2 },
    'LSHIFT' => ->(value, times) { value << times },
    'RSHIFT' => ->(value, times) { value >> times },
    'OR' => ->(value1, value2) { value1 | value2 }
  }

  evaluated = Set.new

  until evaluated.include?('a')
    circuits.each do |k, v|
      # size 1, integer || look-up
      if v.size == 1
        if circuits.key?(v[0]) && evaluated.include?(v[0])
          circuits[k] = circuits[v[0]]
          evaluated.add(k)
        elsif !circuits.key?(v[0])
          circuits[k] = v[0].to_i
          evaluated.add(k)
        end
        next
      end

      # size 2, NOT integer || look-up
      if v.size == 2
        if circuits.key?(v[1]) && evaluated.include?(v[1])
          circuits[k] = commands['NOT'].call(circuits[v[1]])
          evaluated.add(k)
        elsif !circuits.key?(v[1])
          circuits[k] = commands['NOT'].call(v[1].to_i)
          evaluated.add(k)
        end
      end

      # size 3, AND OR LSHIFT RSHIFT
      next unless v.size == 3

      if %w[AND OR].include?(v[1])
        left = nil
        right = nil
        if circuits.key?(v[0]) && evaluated.include?(v[0])
          left = circuits[v[0]]
        elsif !circuits.key?(v[0])
          left = v[0].to_i
        end

        if circuits.key?(v[2]) && evaluated.include?(v[2])
          right = circuits[v[2]]
        elsif !circuits.key?(v[2])
          right = v[2].to_i
        end

        if left && right
          circuits[k] = commands[v[1]].call(left, right)
          evaluated.add(k)
        end
      end

      if %w[LSHIFT RSHIFT].include?(v[1])
        if circuits.key?(v[0]) && evaluated.include?(v[0])
          circuits[k] = commands[v[1]].call(circuits[v[0]], v[2].to_i)
          evaluated.add(k)
        elsif !circuits.key?(v[0])
          circuits[k] = commands[v[1]].call(v[0].to_i, v[2].to_i)
          evaluated.add(k)
        end
      end
    end
  end
  # p circuits
  p circuits['a']
end
path = 'Inputs/day-07-b.txt'

input = parse_input(path)

solve_part1(input)
