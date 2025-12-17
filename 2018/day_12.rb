# frozen_string_literal: true

def parse_input(path)
  rules = {}
  File.readlines(path, chomp: true).map { |l| l.split(' => ') }.each do |pattern, result|
    rules[pattern] = result
  end
  rules
end

def solve_part1(row, rules)
  left_pots = 0

  2000.times do |generation|
    puts generation if (generation % 100_000).zero?
    if row[0] == '#'
      row = "..#{row}"
      left_pots += 2
    end
    row += '..' if row[-1] == '#'
    new_row = ''
    (0...row.size).each do |i|
      eval_str = if i < 2
                   (i.zero? ? '..' : ".#{row[i - 1]}") + row[i, 3]
                 elsif i >= row.size - 2
                   row[i - 2, 3] + (i == row.size - 1 ? '..' : "#{row[i + 1]}.")
                 else
                   row[i - 2, 5]
                 end
      new_row += rules[eval_str].nil? ? '.' : rules[eval_str]
    end
    row = new_row
    # puts row
  end

  count = 0
  row[left_pots..].chars.each_with_index do |c, i|
    count += i if c == '#'
  end
  row[0...left_pots].chars.each_with_index do |c, i|
    count -= left_pots - i if c == '#'
  end
  count
end

path = 'Inputs/day-12.txt'
rules = parse_input(path)
input = '.##..##..####..#.#.#.###....#...#..#.#.#..#...#....##.#.#.#.#.#..######.##....##.###....##..#.####.#'
# input = "#..#.#..##......###...###"
puts "part 1: #{solve_part1(input, rules)}"
