# frozen_string_literal: true

def parse_input(path)
  File.read(path).split("\n").map(&:split)
end

def solve_part1(input)
  system = {}
  cwd = ''
  system['/'] = []
  while input.size.positive?
    cmd = input.shift

    if cmd[1] == 'cd'
      if cmd[2] == '..'
        system[cwd].each do |f|
          cwd = f[1] if f[0] == 'parent'
          break
        end
      elsif cmd[2] == '/'
        cwd = '/'
      else

        system[cmd[2]].push(['parent', cwd])
        cwd = cmd[2]
      end
      next
    end

    next unless cmd[1] == 'ls'

    while input.size.positive? && input.first[0] != '$'
      file = input.shift

      if file[0] == 'dir'
        system[cwd].push(['dir', file[1], cwd])
        system[file[1]] = []
      else

        system[cwd].push(['file', file[1], file[0].to_i])
      end
    end

  end

  dir_sizes = {}
  leaf_dirs = Set.new
  system.each do |k, v|
    dir_sizes[k] = 0
    has_dir = false
    v.each do |f|
      dir_sizes[k] += f[2] if f[0] == 'file'
      has_dir = true if f[0] == 'dir'
    end
    leaf_dirs.add(k) unless has_dir
  end

  leaf_dirs.each do |dir|
    node = system[dir]
    node.each do |f|
      if f[0] == 'parent'

      end
    end
  end
end

def solve_part2(input); end

path = 'Inputs/day-07.txt'
input = parse_input(path)
part_1 = solve_part1(input)
part_2 = solve_part2(input)

puts "part_1: #{part_1}"
puts "part_2: #{part_2}"
