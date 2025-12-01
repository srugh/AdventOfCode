

program = File.read("Inputs/day-02.txt").split(",").map {|i| i.to_i}
desired = 19690720
program[1] = 12
program[2] = 2
offset = 0
while program[0] != desired
  0.upto(99) do |i|
    break if program[0] == desired
    0.upto(99) do |j|
      program = File.read("Inputs/day-02.txt").split(",").map {|i| i.to_i}
      offset = 0
      program[1] = i
      program[2] = j
      while true
        opcode = program[offset]
        case opcode
        when 1
          program[program[offset+3]] = program[program[offset+1]] + program[program[offset+2]]
        when 2
          program[program[offset+3]] = program[program[offset+1]] * program[program[offset+2]]
        when 99
          break
        end
        offset += 4
      end
      puts "i: #{i}, j: #{j}" if program[0] == desired
      puts 100 * i + j  if program[0] == desired
      return if program[0] == desired
    end
  end
end


