def parse_input(path)
  data = []
  happiness = Hash.new  { |hash, key| hash[key] = {} }
  File.readlines(path, chomp: true).each do |line|
    temp = line.split
    data.push([temp[0], temp[3].to_i, temp[6].to_i, temp[13].to_i])
  end
  data
end

def solve_part_1(input)
  duration = 2503
  total_distances = []

  input.each do |reindeer|
    name, speed, time, rest = reindeer

    full_runs = duration / (time+rest)
    remaining_time = duration % (time+rest)
    extra = remaining_time <= time ? remaining_time : time
    total = time * speed * full_runs + speed * extra

    puts name
    puts full_runs
    puts remaining_time
    puts total 
    puts 

    total_distances.push(total)
  end
  total_distances.max
end

def solve_part_2(input)
  duration = 2503
  racers = Hash.new
  oracle = Hash.new
  scores = Hash.new
  distances = Hash.new

  input.each do |reindeer|
    name, speed, time, rest = reindeer
    racers[name] = [speed, time, rest]
    oracle[name] = [time, rest]
    scores[name] = 0
    distances[name] = 0
  end

  duration.times do |i|
    racers.each do |name, v|
      if v[1] > 0
        distances[name] += v[0]
        racers[name][1] -= 1
      else 
        racers[name][2] -= 1
      end

      if racers[name][2] == 0
        racers[name][1] = oracle[name][0]
        racers[name][2] = oracle[name][1]
      end
    end
    max = distances.values.max
    distances.select { |k, v| v == max}.keys.each do |leader|
      scores[leader] += 1
    end
  end
  
  scores.values.max
end


path = "Inputs/day-14.txt"
input = parse_input(path)
#part_1 = solve_part_1(input)
part_2 = solve_part_2(input)
#puts "part_1: #{part_1}"
puts "part_2: #{part_2}"