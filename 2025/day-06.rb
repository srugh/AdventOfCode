def parse_input(path)
  File.read(path).split(/\n/).map{|line| line.split.map{|i| i.match(/\d+/) == nil ? i : i.to_i}}
end

def parse_input_2(path)
  File.readlines(path, chomp: true).map(&:chars)
end

def solve_part_1(rows)
  ops     = rows[-1]
  answers = rows[-2].dup

  rows[0...-2].each do |row|
    row.each_with_index do |val, idx|
      answers[idx] = ops[idx] == "*" ? answers[idx] * val : answers[idx] + val
    end
  end
  answers.sum
end

def solve_part_2(grid)
  rows, cols = grid.size, grid[0].size
  operators = []
  
  grid.last.each_with_index do |c, idx|
    next if c == " "
    operators.push([idx, c])
  end
  
  ranges = []
  operators.each_with_index do |(col, op), i|
    start_col = col
    end_col   = (i + 1 < operators.size ? operators[i + 1][0] - 1 : cols - 1)
    ranges.push([start_col, end_col])
  end
  
  answers = []
  ranges.each_with_index do |(start_c, end_c), i|
    op = operators[i][1]

    numbers = []
    (start_c..end_c).each do |c|
      digits = []
      (0...(rows - 1)).each do |r|
        ch = grid[r][c]
        digits.push(ch) if ch =~ /\d/
      end

      next if digits.empty?

      num = digits.join.to_i
      numbers.push(num)
    end

    val = 
    if op == "*"
      numbers.reduce(1, :*)
    else
      numbers.sum
    end

    answers.push(val)
  end
  answers.sum
end

path = "Inputs/day-06.txt"
input = parse_input(path)
puts "part 1: #{solve_part_1(input)}"

input_2 = parse_input_2(path)
puts "part 2: #{solve_part_2(input_2)}"