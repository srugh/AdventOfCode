def parse_input(path) 
  graph = {}
  File.readlines(path, chomp: true).each do |line|
    l, r = line.split(": ", 2)
    graph[l] = r.split
  end
  graph
end

def dfs(graph, current_node, target, visited)
  return 1 if current_node == target
    
  count = 0
  graph[current_node]&.each do |neighbor|
    next if visited[neighbor]
    visited[neighbor] = true
    count += dfs(graph, neighbor, target, visited)
    visited.delete(neighbor)
  end
  count
end

def solve_part_1(graph)
  start_node, target = "you", "out"
  dfs(graph, start_node, target, start_node => true)
end

def solve_part_2(graph)
  memo = {}

  svr_dac = fast_find(graph, "svr", "dac", ["fft", "out"].freeze, memo)
  svr_fft = fast_find(graph, "svr", "fft", ["dac", "out"].freeze, memo)
  dac_fft = fast_find(graph, "dac", "fft", ["svr", "out"].freeze, memo)
  fft_dac = fast_find(graph, "fft", "dac", ["svr", "out"].freeze, memo)
  fft_out = fast_find(graph, "fft", "out", ["dac", "svr"].freeze, memo)
  dac_out = fast_find(graph, "dac", "out", ["svr", "fft"].freeze, memo)

  [svr_fft * fft_dac  * dac_out, svr_dac  * dac_fft * fft_out].max
end

def fast_find(graph, start_node, target, ignore, memo)
  key = [start_node, target, ignore].freeze
  return memo[key] if memo.key?(key)
  return memo[key] = 1 if start_node == target

  memo[key] = graph[start_node].to_a.sum do |neighbor|
    next 0 if ignore.include?(neighbor)
    fast_find(graph, neighbor, target, ignore, memo)
  end
end

path = "Inputs/day-11.txt"
graph = parse_input(path)
puts "part 1: #{solve_part_1(graph)}"
puts "part 2: #{solve_part_2(graph)}"