# frozen_string_literal: true

def parse_input(path)
  graph = Hash.new { |hash, key| hash[key] = {} }
  File.readlines(path, chomp: true).each do |line|
    l, r = line.split('; ')

    l_parts = l.split
    valve = l_parts[1]
    rate = l_parts.last.scan(/(\d+)/).flatten.first.to_i

    nbrs = r.scan(/([A-Z]+)/).flatten

    graph[valve] = {
      rate: rate,
      nbrs: nbrs
    }
  end
  graph
end

def solve_part1(graph)
  p graph
  false
end

path = 'Inputs/day-16.txt'
graph = parse_input(path)
puts "part 1: #{solve_part1(graph)}"
