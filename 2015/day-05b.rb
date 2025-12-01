
def has_repeating_pair?(string)
    string.match(/(..).*\1/)
end
  
def has_repeating_letter_with_gap?(string)
    string.match(/(.).\1/)
end

def read_data(input_file)
    File.read(input_file).lines.map { |line| line.strip }
end

def passes_all_checks?(string)
    has_repeating_pair?(string) && has_repeating_letter_with_gap?(string)
end

def calculate_nice_strings(strings)
    strings.select{ |string| passes_all_checks?(string)}.size
end

input_file = "Inputs/day-05.txt"

strings = read_data(input_file)
puts "Total nice strings: #{calculate_nice_strings(strings)}"