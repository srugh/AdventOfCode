require 'csv'

def read_data(input_file)
    input_sections = File.read(input_file).split("\n\n")

    rules = input_sections[0].lines.map { |line| line.strip.split('|').map(&:to_i) }
    updates = input_sections[1].lines.map { |line| line.strip.split(',').map(&:to_i) }

    [rules, updates]
end

def valid_update?(rules, update)
    rules.all? do |before, after|
        before_pos = update.index(before)
        after_pos = update.index(after)

        before_pos.nil? || after_pos.nil? || before_pos < after_pos
    end
end

def filter_invalid_updates(rules, updates)
    updates.reject { |update| valid_update?(rules, update) }
end

def clean_update(rules, update)
    # Filter only the relevant rules for the current update
    relevant_rules = rules.select { |before, after| update.include?(before) && update.include?(after) }
  
    sorted = []
  
    # Process each page in the update
    until update.empty?
        # Find the next page that can be inserted (all dependencies are satisfied)
        next_page = update.find do |page|
            dependencies = relevant_rules.select { |_, after| after == page }.map(&:first)
            dependencies.all? { |dep| sorted.include?(dep) }
        end
  
        # Insert the next page into sorted and remove it from the update
        sorted << next_page
        update.delete(next_page)
    end
  
    sorted
end
  
def middle_element(update)
    update[update.size / 2]
end

def calculate_total_for_incorrect(rules, updates)
    invalid_updates = filter_invalid_updates(rules, updates)

    total = invalid_updates.map do |update|
        corrected = clean_update(rules, update)
        middle = middle_element(corrected)

        middle
    end.sum

    total
end

# Run Script
#file = "Inputs/sample.txt"
file = "Inputs/input1.txt"
rules, updates = read_data(file)


# Calculate and print the total result
puts "Total: #{calculate_total_for_incorrect(rules, updates)}"
