# frozen_string_literal: true

def parse_input(input_file)
  network = {}
  parts = File.read(input_file).split("\n\n")

  instructions = parts[0].chomp.chars

  parts[1].split("\n").each do |line|
    temp = line.chomp.scan(/[A-Z0-9]{3}/)
    network[temp[0]] = [temp[1], temp[2]]
  end

  [instructions, network]
end

def navigate(instructions, network)
  cur_node = 'AAA'
  final_node = 'ZZZ'
  count = 0
  puts "start_node: #{cur_node} \t end_node: #{final_node}"
  loop do
    instructions.each do |instruction|
      cur_node = if instruction == 'L'
                   network[cur_node][0]
                 # puts "instruction: #{instruction} \t cur_node: #{cur_node}"
                 else
                   network[cur_node][1]
                   # puts "instruction: #{instruction} \t cur_node: #{cur_node}"
                 end
      count += 1

      return count if cur_node == final_node
    end
  end
  count
end

def check_all_nodes_final(nodes)
  # p nodes
  nodes.size == nodes.select { |k, _v| k[/[A-Z0-9]{2}Z/] }.size
end

def navigate_ghost(instructions, network)
  # cur_node = ""
  count = 0
  start_nodes = Set.new(network.keys.select { |k| k[/[A-Z0-9]{2}A/] })

  nodes_steps = {}

  start_nodes.each do |node|
    cur_node = node
    count = 0
    done = false
    loop do
      instructions.each do |instruction|
        cur_node = if instruction == 'L'
                     network[cur_node][0]
                   # puts "instruction: #{instruction} \t cur_node: #{cur_node}"
                   else
                     network[cur_node][1]
                     # puts "instruction: #{instruction} \t cur_node: #{cur_node}"
                   end
        count += 1

        next unless cur_node.chars[2] == 'Z'

        nodes_steps[node] = count
        done = true
        break
      end
      break if done
    end
  end

  val_arr = []
  nodes_steps.each_value do |val|
    val_arr.push(val)
  end

  val_arr.reduce(:lcm)
end
input_file = 'inputs/day-08-input.txt'

instructions, network = parse_input(input_file)
count = navigate_ghost(instructions, network)

puts "total hops: #{count}"
