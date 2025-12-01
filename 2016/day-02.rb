def parse_input(path)
  File.read(path).split(/\n/)
end

def solve_part_1(input)
  moves = Hash.new
  moves["U"] = [-1, 0]
  moves["D"] = [1, 0]
  moves["L"] = [0, -1]
  moves["R"] = [0, 1]

  start_pos = [1, 1]
  code = ""
  pos = start_pos
  input.each do |steps|
    steps.each_char do |step|
      next_step = moves[step].zip(pos).map { |a, b| a + b }
      pos = next_step if in_bounds?(next_step)
    end
    code += calc_button(pos)
  end
  code
end

def calc_button(pos)
  case pos
  when [0, 0]
    return "1"
  when [0, 1]
    return "2"
  when [0, 2]
    return "3"
  when [1, 0]
    return "4"
  when [1, 1]
    return "5"
  when [1, 2]
    return "6"
  when [2, 0]
    return "7"
  when [2, 1]
    return "8"
  when [2, 2]
    return "9"
  end
end

def in_bounds?(pos)
  pos[0] >= 0 && pos[0] <= 2 && pos[1] >= 0 && pos[1] <= 2
end


def solve_part_2(input)
  moves = Hash.new
  moves["U"] = [-1, 0]
  moves["D"] = [1, 0]
  moves["L"] = [0, -1]
  moves["R"] = [0, 1]

  start_pos = [2, 0]
  code = ""
  pos = start_pos
  input.each do |steps|
    steps.each_char do |step|
      next_step = moves[step].zip(pos).map { |a, b| a + b }
      pos = next_step if in_bounds_2?(next_step)
    end
    code += calc_button_2(pos)
  end
  code
end

def calc_button_2(pos)
  case pos
  when [0, 2]
    return "1"
  when [1, 1]
    return "2"
  when [1, 2]
    return "3"
  when [1, 3]
    return "4"
  when [2, 0]
    return "5"
  when [2, 1]
    return "6"
  when [2, 2]
    return "7"
  when [2, 3]
    return "8"
  when [2, 4]
    return "9"
  when [3, 1]
    return "A"
  when [3, 2]
    return "B"
  when [3, 3]
    return "C"
  when [4, 2]
    return "D"
  end
end

def in_bounds_2?(pos)
  valid = Set.new
  valid.add([0,2])

  valid.add([1,1])
  valid.add([1,2])
  valid.add([1,3])

  valid.add([2,0])
  valid.add([2,1])
  valid.add([2,2])
  valid.add([2,3])
  valid.add([2,4])

  valid.add([3,1])
  valid.add([3,2])
  valid.add([3,3])

  valid.add([4,2])

  return valid.include?(pos)
end


path = "Inputs/day-02.txt"
input = parse_input(path)
p solve_part_1(input)
p solve_part_2(input)