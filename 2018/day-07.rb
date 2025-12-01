require 'set'

# Define a Worker class to track current task and remaining time
class Worker
  attr_accessor :current_step, :remaining_time

  def initialize
    @current_step = nil
    @remaining_time = 0
  end

  # Assign a new step to the worker
  def assign_step(step, step_duration)
    @current_step = step
    @remaining_time = step_duration
  end

  # Process one second of work
  # Returns the completed step if done, else nil
  def work_one_second
    if @current_step
      @remaining_time -= 1
      if @remaining_time <= 0
        completed_step = @current_step
        @current_step = nil
        return completed_step
      end
    end
    nil
  end

  # Check if the worker is idle
  def idle?
    @current_step.nil?
  end
end

# Method to parse a single instruction line
def parse_instruction(line)
  if line =~ /Step (\w) must be finished before step (\w) can begin./
    prerequisite = $1
    step = $2
    return prerequisite, step
  else
    raise "Invalid instruction format: #{line}"
  end
end

# Building the dependencies hash
def build_dependencies(instructions)
  dependencies = Hash.new { |hash, key| hash[key] = Set.new }
  steps = Set.new

  instructions.each do |line|
    prereq, step = parse_instruction(line)
    dependencies[step].add(prereq)
    steps.add(prereq)
    steps.add(step)
  end

  return dependencies, steps
end

# Read instructions from a file
def read_instructions(file_path)
  instructions = []
  File.foreach(file_path) do |line|
    instructions << line.strip
  end
  instructions
end

# Calculate the duration of a step
def step_duration(step, base_duration)
  base_duration + (step.ord - 'A'.ord + 1)
end

# Detect cycles using Depth-First Search (DFS)
def detect_cycles(dependencies, steps)
  visited = {}
  stack = {}

  steps.each do |step|
    if !visited[step]
      return true if dfs_cycle_detect(step, dependencies, visited, stack)
    end
  end
  false
end

def dfs_cycle_detect(current, dependencies, visited, stack)
  visited[current] = true
  stack[current] = true

  dependencies[current].each do |neighbor|
    if !visited[neighbor] && dfs_cycle_detect(neighbor, dependencies, visited, stack)
      return true
    elsif stack[neighbor]
      return true
    end
  end

  stack[current] = false
  false
end

# Determine the order of steps with multiple workers and time
def determine_step_order_with_workers(dependencies, steps, worker_count, base_duration)
  # Initialize workers
  workers = Array.new(worker_count) { Worker.new }

  # Sets to keep track of step statuses
  completed_steps = Set.new
  in_progress_steps = Set.new

  # Initialize available steps: steps with no prerequisites
  available_steps = steps.select { |step| dependencies[step].empty? }.sort

  # Current time in seconds
  time = 0

  # Loop until all steps are completed
  while completed_steps.size < steps.size
    # Assign available steps to idle workers
    workers.each do |worker|
      next unless worker.idle?

      if available_steps.any?
        next_step = available_steps.shift
        duration = step_duration(next_step, base_duration)
        worker.assign_step(next_step, duration)
        in_progress_steps.add(next_step)
        # Uncomment the line below for debugging assignments
        # puts "Time #{time}: Assigned Step #{next_step} to Worker #{workers.index(worker)+1} (Duration: #{duration}s)"
      end
    end

    # Process one second of work for each worker
    completed_this_second = []
    workers.each do |worker|
      completed_step = worker.work_one_second
      if completed_step
        completed_this_second << completed_step
        in_progress_steps.delete(completed_step)
        # Uncomment the line below for debugging completions
        # puts "Time #{time}: Step #{completed_step} completed by Worker #{workers.index(worker)+1}"
      end
    end

    # Update completed steps and available steps
    completed_this_second.each do |step|
      completed_steps.add(step)

      # Remove this step from other steps' dependencies
      dependencies.each do |step_key, prereqs|
        prereqs.delete(step)
      end

      # Find new available steps: steps whose prerequisites are all completed
      dependencies.each do |step_key, prereqs|
        if prereqs.empty? && !completed_steps.include?(step_key) && !in_progress_steps.include?(step_key) && !available_steps.include?(step_key)
          available_steps << step_key
        end
      end

      # Sort available steps alphabetically
      available_steps.sort!
    end

    # Increment time
    time += 1
  end

  return time
end

# Main Execution Flow for Part Two
def main_part_two
  input_file = "Inputs/day-07.txt" # Replace with your actual input file path
  instructions = read_instructions(input_file)
  dependencies, steps = build_dependencies(instructions)

  # Detect cycles before proceeding
  if detect_cycles(dependencies, steps)
    puts "Error: The input contains a cycle in the dependencies. Please remove or correct the conflicting instructions."
    exit
  end

  # Parameters
  worker_count = 5
  base_duration = 60

  total_time = determine_step_order_with_workers(dependencies, steps, worker_count, base_duration)
  puts "Total time to complete all steps: #{total_time} seconds."
end

# Run the script
main_part_two
