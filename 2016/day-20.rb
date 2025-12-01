def parse_file(path)
  File.read(path).split(/\n/).map {|r| r.split("-").map { |i| i.to_i}}.sort_by { |inner_array| inner_array[0] }
end

def solve_part_1(input)
  ranges = []
  input.each do |r|
    ranges.push(Range.new(r[0], r[1]))
  end

  merged = [ranges.first]  
  ranges[1..-1].each do |current_range|
    last_merged_range = merged.last

    # Check for overlap or adjacency
    # Adjacency means current_range.begin is at most 1 greater than last_merged_range.end
    if current_range.begin <= last_merged_range.end + 1
      # Merge overlapping/adjacent ranges by extending the end of the last merged range
      # We create a new Range object for the merged interval
      new_end = [last_merged_range.end, current_range.end].max
      # Use `...` or `..` depending on whether the original ranges were exclusive or inclusive
      # Assuming inclusive `..` for simplicity here
      merged[-1] = (last_merged_range.begin..new_end)
    else
      # No overlap, so add the current range to the result list
      merged << current_range
    end
  end
  
  first_valid_int = merged.first.end + 1
 
  possible_ips = 0
  0.upto(merged.size-2) do |i|
    possible_ips += merged[i+1].begin - merged[i].end - 1
  end

  possible_ips_2 = 0
  0.upto(ranges.size-2) do |i|
    possible_ips_2 += ranges[i+1].begin - ranges[i].end
  end

  [first_valid_int, possible_ips]
end

path = "Inputs/day-20.txt"
input = parse_file(path)
p solve_part_1(input)