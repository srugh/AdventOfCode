# frozen_string_literal: true

def parse_input(path)
  ports = {}
  File.readlines(path, chomp: true).each do |line|
    nums = line.split('/').map(&:to_i)
    ports[nums] = false
  end
  ports
end

def dfs(ports, current_node, target, path, all_paths)
  ports[current_node] = true
  path << current_node

  neighbors = ports.select { |key, val| (key[0] == target || key[1] == target) && !val }

  if neighbors.size.positive?
    neighbors&.each_key do |n|
      next if ports[n]

      ports[n] = true
      t = n[0] == target ? n[1] : n[0]
      dfs(ports, n, t, path, all_paths)
      ports[n] = false
      path.pop
    end
  else
    all_paths << path.dup
  end
  ports[current_node] = false
  all_paths
end

def solve(ports)
  all_paths = []
  starts = ports.keys.select { |key| key[0].zero? || key[1].zero? }
  starts.each do |port|
    dfs(ports, port, port.max, [], all_paths)
  end

  largest = longest = longest_strength = -1

  all_paths.each do |path|
    sum = path.sum(&:sum)
    largest = sum if sum > largest

    size = path.size
    if size > longest
      longest = size
      longest_strength = sum
    elsif size == longest && sum > longest_strength
      longest_strength = sum
    end
  end

  [largest, longest_strength]
end

path = 'inputs/day-24.txt'
ports = parse_input(path)
largest, longest = solve(ports)
puts "part 1: #{largest}, part 2: #{longest}"
