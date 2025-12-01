def read_data(input_file) 
    answers = []
    equations = []
  
    File.foreach(input_file) do |line|
        # Split the line on the colon and capture the first part and the rest
        first, rest = line.chomp.split(": ", 2)
        answers << first.to_i
        equations << rest.split(" ").map(&:to_i) if rest
    end
  
    [answers, equations]
end

def check_equation(answer, equation)
  operators = ["*", "+", "||"]
  num_slots = equation.size - 1

  # Generate combinations for the slots
  slots_combinations = [[]] # Start with an empty set of combinations

  num_slots.times do
    new_combinations = []
    slots_combinations.each do |combination|
      operators.each do |operator|
        new_combinations << combination + [operator]
      end
    end
    slots_combinations = new_combinations
  end

  # Combine the slots combinations with the characters of string1

  slots_combinations.each do |slots|
    result = []
    equation.each_with_index do |char, index|
      result << char
      result << slots[index] if index < slots.size
    end
    if calc_equation?(result, answer)
      
      return [true, answer]
    end 
  end

  [false, nil]
end

def calc_equation?(eq, answer)
  val1 = eq[0].to_i
  total = 0

  for i in 1..eq.size-1
    op = eq[i]
    i=i+1
    val2 = eq[i].to_i
    if op == "*"
      total = val1 * val2
    elsif op == "+"
      total = val1 + val2
    elsif op == "||"
      str = val1.to_s + val2.to_s
      total = str.to_i
    end

    val1 = total
  end

  total == answer
end

def calc_total_possible_equations(answers, equations)
    good_totals = []
    for i in 0..answers.size-1
        works, total = check_equation(answers[i], equations[i])
        if works
            good_totals << total
        end
    end

    good_totals.sum
end


#input_file = "Inputs/sample.txt"
input_file = "Inputs/input1.txt"

answers, equations = read_data(input_file)

total = calc_total_possible_equations(answers, equations)

puts "Total: #{total}"