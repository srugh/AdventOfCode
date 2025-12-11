require 'tempfile'

def parse_input(path)
  input = []
  replacements = { '#' => '1', '.' => '0' }
  File.readlines(path, chomp: true).each do |line|
    parts = line.split
    pattern = parts.shift[1...-1].gsub(/[#.]/, replacements)
    power = parts.pop
    buttons = []
    
    parts.each do |b|
      buttons.push(b[1...-1].split(',').map(&:to_i))
    end
  
    input.push([pattern, buttons, power[1...-1].split(",").map(&:to_i)])
  end
  input
end

def min_presses_for_machine(pattern, buttons)
  pattern_length = pattern.length
  target = 0  
  pattern.chars.each_with_index do |ch, i|
    target |= (1 << i) if ch == '1'
  end
  button_masks = buttons.map do |idxs|
    mask = 0
    idxs.each { |i| mask |= (1 << i) }
    mask
  end

  start = 0
  return 0 if target == start

  max_state = 1 << pattern_length
  visited = Array.new(max_state, false)
  queue = [[start, 0]]
  visited[start] = true

  until queue.empty?
    state, dist = queue.shift

    button_masks.each do |bm|
      next_state = state ^ bm
      next if visited[next_state]

      return dist + 1 if next_state == target

      visited[next_state] = true
      queue << [next_state, dist + 1]
    end
  end

  # if unreachable (shouldn't happen for valid inputs)
  nil
end

def build_lp_for_machine(buttons, targets)
  b = buttons.length

  objective_terms = (0...b).map { |j| "x#{j}" }.join(" + ")
  lp = +"min: #{objective_terms};\n"

  constraints = []
  targets.each_with_index do |t, i|
    terms = []
    buttons.each_with_index do |idxs, j|
      terms << "x#{j}" if idxs.include?(i)
    end

    constraints << "c#{i + 1}: #{terms.join(' + ')} = #{t};"
  end

  lp << constraints.join("\n") << "\n" unless constraints.empty?

  int_line = "int " + (0...b).map { |j| "x#{j}" }.join(", ") + ";"
  lp << int_line << "\n"

  lp
end

def min_presses_for_jolts(buttons, targets)
  lp_text = build_lp_for_machine(buttons, targets)

  Tempfile.create(["machine", ".lp"]) do |f|
    f.write(lp_text)
    f.flush

    output = `lp_solve #{f.path} 2>/dev/null`
    
    if output =~ /Value of objective function:\s*([0-9]+)/i
      return $1.to_i
    end
  end
end


def solve_part_1(machines)
  machines.sum { |pattern, buttons, _| min_presses_for_machine(pattern, buttons) }
end

def solve_part_2(machines)
  machines.sum do |_pattern, buttons, jolts|
    min_presses_for_jolts(buttons, jolts)
  end
end

path = "Inputs/day-10.txt"
inputs = parse_input(path)
puts "part 1: #{solve_part_1(inputs)}"
puts "part 2: #{solve_part_2(inputs)}"