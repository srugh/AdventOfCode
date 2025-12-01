require 'set'
def parse_input(input_file)
    instructions = []
    compounds = File.read(input_file).chomp.split(", ")
    compounds.each do |compound|
        turn = compound.scan(/[LR]/)
        blocks = compound.scan(/([0-9]{1,3})/)
       
        instructions.push([turn[0], blocks[0][0].to_i])
    end
    instructions
end

def calc_distance(directions)
    facing = "N"
    cur_pos = [0,0]
    visited = Set.new

    directions.each_with_index do |dir, idx|
        delta = []
        turn, blocks = dir
        #visited.add(cur_pos)
        
        puts "\nInstruction: #{idx} \n Current: (#{cur_pos[0]}, #{cur_pos[1]}) \t Turn: #{turn} \t Facing: #{facing} \t Blocks: #{blocks} "
        if turn == "L"
            facing = turn_left(facing)
        elsif turn == "R"
            facing = turn_right(facing)
        end

        delta = move_forward(facing)
        blocks.times do
            cur_pos[0] += delta[0]
            cur_pos[1] += delta[1]

            if visited.include?(cur_pos)
                puts "Revisited Position: #{cur_pos.inspect}"
                return cur_pos[0].abs + cur_pos[1].abs
            end
            visited.add(cur_pos.dup)
        end  
    end
end

def turn_left(cur_facing)
    case cur_facing
    when "N"
        return "W"
    when "W"
        return "S"
    when "S"
        return "E"
    when "E"
        return "N"
    end
end

def turn_right(cur_facing)
    case cur_facing
    when "N"
        return "E"
    when "E"
        return "S"
    when "S"
        return "W"
    when "W"
        return "N"
    end
end

def move_forward(cur_facing)
    case cur_facing
    when "N"
        return [0, 1]      # Increase y-coordinate
    when "E"
        return [1, 0]      # Increase x-coordinate
    when "S"
        return [0, -1]     # Decrease y-coordinate
    when "W"
        return [-1, 0]     # Decrease x-coordinate

    end
end

input_file = "Inputs/day-01-input.txt"

directions = parse_input(input_file)

distance = calc_distance(directions)

puts "total distance is: #{distance}"