def parse_input(path)
  top, bottom = File.read(path).split(/\n\n/, 2)

  [top.split(/\n/).map{|line| line.split("-").map(&:to_i)}.sort, bottom.split("\n").map(&:to_i)]
end

def solve_part_1(ranges, ingredients)
  condensed_ranges = condense_ranges(ranges)

  ingredients.count do |id|
    condensed_ranges.any? { |range_start, range_end|  id.between?(range_start, range_end) }
  end
end

def solve_part_2(ranges)
  condense_ranges(ranges).sum { |range_start, range_end| range_end - range_start + 1 }
end

def condense_ranges(ranges)
  condensed_ranges = [ranges.first]

  ranges[1..-1].each do |current_range|
    last_condensed_range = condensed_ranges.last

    if current_range.first <= last_condensed_range.last + 1
      new_end = [last_condensed_range.last, current_range.last].max
      condensed_ranges[-1] = [last_condensed_range.first,new_end]
    else
      condensed_ranges.push(current_range)
    end
  end
  condensed_ranges
end

path = "Inputs/day-05.txt"
ranges, ingredients = parse_input(path)
puts "part 1: #{solve_part_1(ranges, ingredients)}"
puts "part 2: #{solve_part_2(ranges)}"