# Advent of Code 2018 - Day 8: Memory Maneuver
# Solution to calculate the sum of all metadata entries in the tree.

# Function to parse a node and return the sum of its metadata and the updated index
def parse_node(numbers, index)
    child_count = numbers[index]
    metadata_count = numbers[index + 1]
    index += 2
    metadata_sum = 0
  
    # Recursively parse all child nodes
    child_count.times do
      child_sum, index = parse_node(numbers, index)
      metadata_sum += child_sum
    end
  
    # Read metadata entries and add to sum
    metadata_entries = numbers[index, metadata_count]
    metadata_sum += metadata_entries.sum
    index += metadata_count
  
    return metadata_sum, index
  end
  
  # Function to read input from a file or a string
  def read_input(source)
    if source.is_a?(String) && File.exist?(source)
      # Read from a file
      File.read(source).strip.split.map(&:to_i)
    else
      # Assume source is a string of space-separated numbers
      source.split.map(&:to_i)
    end
  end
  
  # Main execution function
  def main
    # Replace the input below with your actual input as a string or file path
    # Example input provided in the problem description:
    example_input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
  
    # Uncomment the line below to use a file named 'input.txt'
    # numbers = read_input('input.txt')
  
    # Using the example input
    numbers = read_input("Inputs/day-08.txt")
  
    # Parse the tree starting from index 0
    total_metadata_sum, _ = parse_node(numbers, 0)
  
    # Output the result
    puts "The sum of all metadata entries is: #{total_metadata_sum}"
  end
  
  # Run the main function
  main
  