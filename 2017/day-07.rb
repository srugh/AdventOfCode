# frozen_string_literal: true

def parse_input(path)
  tree = {}

  File.readlines(path, chomp: true).each do |line|
    left, right = line.split('->').map(&:strip)
    name, weight_str = left.split
    weight = weight_str[1...-1].to_i

    children = right ? right.split(',').map(&:strip) : []

    tree[name] = { weight: weight, children: children }
  end

  tree
end

def total_weight(name, tree, result)
  node = tree[name]
  children = node[:children]

  return node[:weight] if children.empty?

  child_weights = children.map { |ch| [ch, total_weight(ch, tree, result)] }

  return node[:weight] + child_weights.sum { |_, w| w } if result[:fixed_weight]

  weights = child_weights.map(&:last)
  groups  = weights.group_by { |w| w }

  if groups.size > 1
    correct_weight = groups.max_by { |_, list| list.size }.first
    wrong_weight   = groups.min_by { |_, list| list.size }.first

    wrong_child_name = child_weights.find { |_, w| w == wrong_weight }.first

    diff = correct_weight - wrong_weight
    wrong_node_weight = tree[wrong_child_name][:weight]
    result[:fixed_weight] = wrong_node_weight + diff
  end

  node[:weight] + weights.sum
end

def solve_part1(tree)
  all_nodes     = tree.keys
  all_children  = tree.values.flat_map { |n| n[:children] }.uniq
  (all_nodes - all_children).first
end

def solve_part2(tree)
  root = solve_part1(tree)
  result = { fixed_weight: nil }
  total_weight(root, tree, result)
  result[:fixed_weight]
end

path = 'inputs/day-07.txt'
graph = parse_input(path)
puts "part 1: #{solve_part1(graph)}"
puts "part 2: #{solve_part2(graph)}"
