def read_data(input_file)
    File.read(input_file).lines.map { |line| line.strip.split('x').map(&:to_i) }
end

def calc_areas(gift_dimensions)
    areas = [gift_dimensions[0] * gift_dimensions[1], gift_dimensions[1] * gift_dimensions[2], gift_dimensions[0] * gift_dimensions[2]]
    extra_area = areas.min

    side_areas = areas.map{ |side| side * 2 }.sum
    
    [side_areas, extra_area]

end

def calculate_total_wrapping_paper(all_gift_dimensions)
    all_gift_dimensions.reduce(0) do |total_area, gift_dimensions|
        gift_area, extra_area = calc_areas(gift_dimensions)
        total_area + gift_area + extra_area
    end
end

input_file = "Inputs/day-02.txt"

all_gift_dimensions = read_data(input_file)
puts "Total wrapping paper needed: #{calculate_total_wrapping_paper(all_gift_dimensions)}"