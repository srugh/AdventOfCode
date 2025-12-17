# frozen_string_literal: true

def parse_input(path)
  rules = []
  x, y, z = File.read(path).split("\n\n")
                .map { |chunk| chunk.split("\n") }

  x.each do |line|
    temp = line.scan(/(\d+)-(\d+)/)
    rules.push(temp[0].map(&:to_i))
    rules.push(temp[1].map(&:to_i))
  end

  mine = y[1].split(',').map(&:to_i)

  z.shift
  nearby = z.map do |row|
    row.split(',').map(&:to_i)
  end

  [rules, mine, nearby]
end

def solve_part1(rules, _mine, nearby)
  valid_values = Set.new
  score = 0
  rules.each do |range|
    (range[0]..range[1]).each do |i|
      valid_values.add(i)
    end
  end

  nearby.each do |ticket|
    ticket.each do |val|
      score += val unless valid_values.include?(val)
    end
  end
  score
end

def parse_input_part_2(path)
  rules = {}
  x, y, z = File.read(path).split("\n\n")
                .map { |chunk| chunk.split("\n") }

  x.each do |line|
    temp = line.scan(/(\d+)-(\d+)/)
    temp2 = line.split(':').shift
    rules[temp2] = [temp[0].map(&:to_i), temp[1].map(&:to_i)]
  end

  mine = y[1].split(',').map(&:to_i)

  z.shift
  nearby = z.map do |row|
    row.split(',').map(&:to_i)
  end

  [rules, mine, nearby]
end

# 1) helpers
def valid_for_any_field?(rules, v)
  rules.values.any? { |ranges| ranges.any? { |lo, hi| (lo..hi).cover?(v) } }
end

def valid_for_field?(ranges, v)
  ranges.any? { |lo, hi| (lo..hi).cover?(v) }
end

def solve_part2(_rules_arr, rules_hash, mine, nearby)
  valid_tix = nearby.select { |t| t.all? { |v| valid_for_any_field?(rules_hash, v) } }

  ncols = mine.size
  fields = rules_hash.keys

  # 3) start with all fields per column, then intersect
  cands = Array.new(ncols) { fields.to_set }

  valid_tix.each do |t|
    (0...ncols).each do |j|
      v = t[j]
      cands[j].delete_if { |fname| !valid_for_field?(rules_hash[fname], v) }
    end
  end

  # 4) resolve by elimination
  resolved = {}
  loop do
    singles = cands.each_with_index.select { |s, j| s.size == 1 && !resolved.key?(j) }
    break if singles.empty?

    singles.each do |s, j|
      fname = s.to_a.first
      resolved[j] = fname
      cands.each_with_index { |other, k| other.delete(fname) if k != j }
      cands[j].clear
    end
  end
  # resolved: { column_index => field_name }

  # 5) multiply “departure” values on your ticket
  resolved.select { |_, f| f.start_with?('departure') }
          .keys
          .map { |j| mine[j] }
          .inject(1, :*)
end

path = 'Inputs/day-16.txt'

rules, = parse_input(path)
rules2, mine, nearby = parse_input_part_2(path)

solve_part1(rules, mine, nearby)
part_2 = solve_part2(rules, rules2, mine, nearby)

p part_2

# part_2 = solve_part2(p1.dup, p2.dup)

# puts "part 1: #{part_1}"
# puts "part 2: #{part_2}"
