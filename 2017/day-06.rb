# frozen_string_literal: true

def parse_input(path)
  banks = {}
  File.read(path).split.map(&:to_i).each_with_index do |b, i|
    banks[i] = b
  end
  banks
end

def solve_part1(banks)
  snapshot = Set.new
  bank_count = banks.size

  until snapshot.include?(banks.values.join(','))
    snapshot.add(banks.values.join(','))
    key, val = banks.max_by { |key, value| [value, -key] }
    banks[key] = 0
    idx = (key + 1) % bank_count

    while val.positive?
      banks[idx] += 1
      val -= 1
      idx = (idx + 1) % bank_count
    end
  end

  snapshot.size
end

def solve_part2(banks)
  snapshot = Set.new
  bank_count = banks.size

  until snapshot.include?(banks.values.join(','))
    snapshot.add(banks.values.join(','))
    key, val = banks.max_by { |key, value| [value, -key] }
    banks[key] = 0
    idx = (key + 1) % bank_count

    while val.positive?
      banks[idx] += 1
      val -= 1
      idx = (idx + 1) % bank_count
    end
  end

  snapshot = Set.new
  count = 0
  until snapshot.include?(banks.values.join(','))
    snapshot.add(banks.values.join(',')) if snapshot.empty?
    key, val = banks.max_by { |key, value| [value, -key] }
    banks[key] = 0
    idx = (key + 1) % bank_count

    while val.positive?
      banks[idx] += 1
      val -= 1
      idx = (idx + 1) % bank_count
    end
    count += 1
  end
  count
end

path = 'inputs/day-06.txt'
banks = parse_input(path)
puts "part 1: #{solve_part1(banks)}"
puts "part 2: #{solve_part2(banks)}"
