# frozen_string_literal: true

def parse_input(input_file)
  flights = {}
  File.foreach(input_file) do |line|
    temp = line.chomp.split
    flights[[temp[0], temp[2]]] = temp[4].to_i
    flights[[temp[2], temp[0]]] = temp[4].to_i
  end

  flights
end

def calculate_distance(route, distances)
  distance = 0
  (0...(route.size - 1)).each do |i|
    pair = [route[i], route[i + 1]]
    distance += distances[pair]
  end
  distance
end

# Find the shortest route
def find_shortest_route(distances)
  locations = distances.keys.flatten.uniq
  shortest_distance = 100
  locations.permutation.each_with_index do |route, index|
    distance = calculate_distance(route, distances)
    puts "Route #{index + 1}: #{route.join(' -> ')} = #{distance}"
    shortest_distance = [shortest_distance, distance].max
  end
  shortest_distance
end

input_file = 'Inputs/day-09.txt'

flights = parse_input(input_file)

shortest_flight_path_distance = find_shortest_route(flights)

puts "Shortest path: #{shortest_flight_path_distance}"
