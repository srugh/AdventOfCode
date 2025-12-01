import array

def populate_arrays(file_path, left_array, right_array):
    with open(file_path, 'r') as file:
        for line_number, line in enumerate(file):
            vals = line.strip().split()
            left_array.append(int(vals[0]))
            right_array.append(int(vals[1]))

def calculate_distance(left_array, right_array):
    total_distance = 0

    for i in range(len(left_array)):
        distance = left_array[i] - right_array[i]
        total_distance += abs(distance)
    
    return total_distance

## Initalize and run

# sample_file = "Inputs/sample.txt"
real_file = "Inputs/input-1.txt"

unsorted_left_array = []
unsorted_right_array = []

sorted_left_array = []
sorted_right_array = []

total_distance = 0

# initalize arrays from input file
populate_arrays(real_file, unsorted_left_array, unsorted_right_array)

# sort each array
sorted_left_array = sorted(unsorted_left_array)
sorted_right_array = sorted(unsorted_right_array)

# calculate total distance
total_distance = calculate_distance(sorted_left_array, sorted_right_array)

# print total distance
print(total_distance)

