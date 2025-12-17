# frozen_string_literal: true

def parse_input(input)
  connections = []
  wires = {}
  parts = File.read(input).split("\n\n")

  temp = parts[1].split("\n")
  temp.each do |line|
    temp2 = line.split
    connections.push([temp2[0], temp2[1], temp2[2], temp2[4]])
    wires[temp2[0]] = nil
    wires[temp2[2]] = nil
    wires[temp2[4]] = nil
  end

  temp = parts[0].split("\n")
  temp.each do |line|
    temp2 = line.split(': ')
    wires[temp2[0]] = temp2[1].to_i
  end

  [wires, connections]
end

def calc_z_values(wires, connections)
  remaining = Set.new

  wires.each do |key, value|
    remaining.add(key) if value != 1 && value != 0
  end
  p remaining
  while remaining.size.positive?
    connections.each do |connection|
      a, op, b, c = connection
      puts "a: #{a} \t b: #{b}"
      puts '--'
      next unless !wires[a].nil? && !wires[b].nil?

      remaining.delete(c)

      puts "a: #{wires[a]} \t op: #{op} \t b: #{wires[b]} \t c: #{c}"

      case op
      when 'AND'
        wires[c] = if wires[a] == 1 && wires[b] == 1
                     1
                   else
                     0
                   end
        puts "c: #{wires[c]}"
        puts
      when 'OR'
        wires[c] = if wires[a] == 1 || wires[b] == 1
                     1
                   else
                     0
                   end
        puts "c: #{wires[c]}"
        puts
      when 'XOR'
        wires[c] = if wires[a] == wires[b]
                     0
                   else
                     1
                   end
        puts "#{c}: #{wires[c]}"
        puts
      end
    end
  end

  z = wires.select { |key, _value| key.to_s.match(/^z/) }
  z_array = Array.new(z.size)
  z.each do |key, value|
    index = key.chars[1] + key.chars[2]
    z_array[index.to_i] = value
  end

  p z
  p z_array

  puts z_array.reverse.join
  z_array.reverse.join
end

input = 'Inputs/input.txt'

wires, connections = parse_input(input)
z_val = calc_z_values(wires, connections)

puts "z_val: #{z_val.to_i(2)}"
