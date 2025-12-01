def parse_file(path)
  File.read(path).split(/\n/).map {|line| line.split.map{|i| i.to_i}}
end

def solve_part_1(input)
  score = 0
  input.each_with_index do |seq, idx|
    reductions = []
    reductions.push(seq.dup)
    while reductions.last.count(0) == 0 || reductions.last.count(0) != reductions.last.size  
      reductions.push(reduce_seq(reductions.last.dup))
    end
    reductions.reverse!
    
    reductions[0].push(0)
    0.upto(reductions.size-2) do |i|
      reductions[i+1].push(reductions[i].last + reductions[i+1].last)
    end

    score += reductions.last.last
  end
  score
end

def solve_part_2(input)
  score = 0
  input.each_with_index do |seq, idx|
    reductions = []
    reductions.push(seq.dup)
    while reductions.last.count(0) == 0 || reductions.last.count(0) != reductions.last.size  
      reductions.push(reduce_seq(reductions.last.dup))
    end
    reductions.reverse!
    
    reductions[0].unshift(0)
    0.upto(reductions.size-2) do |i|
      reductions[i+1].unshift(reductions[i+1].first - reductions[i].first )
    end

    p reductions
    score += reductions.last.first
  end
  score
end
  

def reduce_seq(seq)
  reduced_seq = []
  0.upto(seq.size-2) do |i|
    reduced_seq.push(seq[i+1]-seq[i])
  end
  reduced_seq
end

path = "Inputs/day-09.txt"
input = parse_file(path)
puts "part_1: #{solve_part_1(input)}"
puts "part_2: #{solve_part_2(input)}"