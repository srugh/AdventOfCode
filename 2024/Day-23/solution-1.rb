require 'set'

# =========================
# Part 1: Identify All Unique Triangles
# =========================

# Function to parse the input file and return an array of connection pairs
def parse_input(file)
  loc_pairs = []
  File.readlines(file, chomp: true).each do |line|
    parts = line.split("-")
    loc_pairs.push(line)
  end
  loc_pairs
end

# Function to build the adjacency list from connection pairs
def build_adjacency_list(loc_pairs)
  adjacency = Hash.new { |hash, key| hash[key] = Set.new }

  loc_pairs.each do |connection|
    a, b = connection.split('-')
    adjacency[a].add(b)
    adjacency[b].add(a)
  end

  adjacency
end

# Function to find all unique triangles in the adjacency list
def find_unique_triangles(adjacency)
  triangles = Set.new

  adjacency.each do |node, neighbors|
    sorted_neighbors = neighbors.to_a.sort
    sorted_neighbors.each_with_index do |neighbor1, index|
      # Iterate through pairs of neighbors where neighbor2 > neighbor1 to avoid duplicate pairs
      sorted_neighbors[(index + 1)..-1].each do |neighbor2|
        # Check if neighbor1 and neighbor2 are connected
        if adjacency[neighbor1].include?(neighbor2)
          # Sort the triangle to ensure uniqueness
          triangle = [node, neighbor1, neighbor2].sort
          triangles.add(triangle)
        end
      end
    end
  end

  triangles
end

# =========================
# Part 2: Find the Largest Clique
# =========================

# Function to find all maximal cliques using the Bron-Kerbosch algorithm
def bron_kerbosch(r, p, x, adjacency, cliques)
  if p.empty? && x.empty?
    cliques << r
    return
  end

  # Choose a pivot with the highest degree in P ∪ X
  pivot = (p + x).max_by { |node| adjacency[node].size } || nil
  neighbors_of_pivot = pivot ? adjacency[pivot] : Set.new

  # Iterate over nodes not connected to the pivot
  (p - neighbors_of_pivot).each do |node|
    bron_kerbosch(
      r + [node],
      p & adjacency[node],
      x & adjacency[node],
      adjacency,
      cliques
    )
    p.delete(node)
    x.add(node)
  end
end

# Function to find the largest clique in the adjacency list
def find_largest_clique(adjacency)
  cliques = []
  p = adjacency.keys.to_set
  r = []
  x = Set.new
  bron_kerbosch(r, p, x, adjacency, cliques)

  # Find the clique with the maximum size
  largest_clique = cliques.max_by { |clique| clique.size }
  largest_clique
end

# =========================
# Main Execution Flow
# =========================

# Replace "Inputs/input.txt" with the path to your actual input file
input_file = "Inputs/input.txt"

# Check if the input file exists
unless File.exist?(input_file)
  puts "Input file '#{input_file}' not found. Please ensure the file exists in the 'Inputs' directory."
  exit
end

# Part 1: Find and print all unique triangles
loc_pairs = parse_input(input_file)
adjacency = build_adjacency_list(loc_pairs)
triangles = find_unique_triangles(adjacency)

puts "----- Part 1: Identify All Unique Triangles -----"
triangles.each do |triangle|
  puts triangle.join(',')
end
puts "Total Triangles: #{triangles.size}"
puts

# Part 2: Find and print the largest clique (LAN party password)
largest_clique = find_largest_clique(adjacency)

if largest_clique.nil? || largest_clique.empty?
  puts "----- Part 2: Find the Largest Clique -----"
  puts "No cliques found in the network."
else
  sorted_clique = largest_clique.sort
  password = sorted_clique.join(',')
  puts "----- Part 2: Find the Largest Clique -----"
  puts "Largest Clique (LAN Party Computers): #{password}"
  puts "Password to Enter the LAN Party: #{password}"
end
