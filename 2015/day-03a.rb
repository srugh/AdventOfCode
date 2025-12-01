

def read_data(input_file)
    instructions = File.read(input_file)

    instructions
end

def calc_houses_visited(directions)
    moves = Hash.new
    moves["^"] = [-1, 0]
    moves[">"] = [0, 1]
    moves["v"] = [1, 0]
    moves["<"] = [0, -1]

    houses_visited = []
    houses_visited.push([0,0])

    directions.each_char do |direction|
        next_row = houses_visited.last[0] + moves[direction][0]
        next_col = houses_visited.last[1] + moves[direction][1]
        houses_visited.push([next_row, next_col])
    end
    
    houses_visited.uniq.size

end

input_file = "Inputs/day-03.txt"

directions = read_data(input_file)

puts "Total houses with a present #{calc_houses_visited(directions)}"

