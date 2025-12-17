# frozen_string_literal: true

def parse_input(path)
  graph = {}
  File.readlines(path, chomp: true).map { |line| line.split(' <-> ') }.each do |l, r|
    graph[l.to_i] = r.split(', ').map(&:to_i)
  end
  graph
end

def bfs(graph, target)
  queue = [target]
  visited = { target => true }
  reachable_nodes = [target]

  until queue.empty?
    current_node = queue.shift

    graph[current_node].each do |neighbor|
      next if visited[neighbor]

      visited[neighbor] = true
      reachable_nodes << neighbor
      queue << neighbor
    end
  end

  reachable_nodes
end

def solve_part1(graph)
  bfs(graph, 0).size
end

def solve_part2(graph)
  visited = {}
  count = 0
  graph.each_key do |node|
    next if visited[node]

    reachable = bfs(graph, node)
    reachable.each { |n| visited[n] = true }
    count += 1
  end
  count
end

path = 'Inputs/day-12.txt'
graph = parse_input(path)

puts "part 1: #{solve_part1(graph)}"
puts "part 2: #{solve_part2(graph)}"
