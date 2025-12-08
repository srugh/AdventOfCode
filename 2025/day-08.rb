def parse_input(path)
  File.readlines(path, chomp: true).map{ |l| l.split(",").map(&:to_i) }
end

def build_sorted_edges(points)
  n = points.size 
  edges = []

  (0...n).each do |p|
    p1, p2, p3 = points[p]
    (p+1...n).each do |q|
      q1, q2, q3 = points[q]

      # don't need square root for actual distance for this scenario
      dist_squared = (p1 - q1)**2 + (p2 - q2)**2 + (p3 - q3)**2
      edges << [dist_squared, p, q]
    end
  end
  edges.sort_by!(&:first)  
end

def find(parent, x)
  parent[x] = find(parent, parent[x]) if parent[x] != x
  parent[x]
end

def union(parent, x, y)
  rx = find(parent, x)
  ry = find(parent, y)
  return false if rx == ry

  parent[ry] = rx
  true
end

def solve_part_1(points)
  n = points.size
  parent = Array.new(n) { |i| i }
  edges = build_sorted_edges(points)

  edges.take(1000).each do |(d, i, j)|
    union(parent, i, j)
  end

  circuit_sizes = Hash.new(0)
  (0...n).each do |i|
    circuit_sizes[find(parent, i)] += 1
  end

  circuit_sizes.values.sort.reverse.first(3).inject(1, :*)
end

def solve_part_2(points)
  n = points.size
  parent = Array.new(n) { |i| i }
  circuits = n 
  last_edge = nil 
  edges = build_sorted_edges(points)

  edges.each do |(_d, i, j)|
    if union(parent, i, j)
      circuits -= 1
      last_edge = [i, j]
      break if circuits == 1
    end
  end
  
  points[last_edge[0]][0] * points[last_edge[1]][0]  
end

path = "Inputs/day-08.txt"
points = parse_input(path)
puts "part 1: #{solve_part_1(points)}"
puts "part 2: #{solve_part_2(points)}"