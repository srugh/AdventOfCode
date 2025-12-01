require 'benchmark'
def load_stones(input_file)
    File.read(input_file).chomp.split(" ").map(&:to_i)
end

def process_stone(cur_stone)
    if cur_stone == 0
        [1]
    elsif cur_stone.digits.size % 2 == 0
        # Split digits into two stones
        digits = cur_stone.to_s
        digits.chars.each_slice(cur_stone.digits.size / 2).map(&:join).map(&:to_i)
    else
        # Replace with single multiplied stone
        [cur_stone * 2024]
    end
end

def calc_stones(stones, blinks)
    new_stones = []

    for i in 0...blinks
        puts "Blink: #{i} starting..."
        elapsed_time = Benchmark.realtime do
            new_stones = []

            
            stones.each_with_index do |stone, idx|
                new_stones.concat(process_stone(stone))
            end
            stones = new_stones

        end
        puts "Blink #{i + 1} took #{elapsed_time.round(4)} seconds"
    end
    stones.size
end

#input_file = "Inputs/sample.txt"
input_file = "Inputs/inputs1.txt"

initial_stones = []

initial_stones = load_stones(input_file)
blinks = 75
total_stones = calc_stones(initial_stones, blinks)

puts "Total stones: #{total_stones}"