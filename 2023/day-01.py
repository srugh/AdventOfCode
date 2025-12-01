import re

def read_input(path):
    with open(path) as f:
        return f.read()
    
def parse_file(raw):
    return raw.splitlines()
   
def solve_part_1(data):
    total = 0
    for str in data:
        integers_as_strings = re.findall(r'\d', str)
        total += int(integers_as_strings[0] + integers_as_strings[-1])
    
    return total

WORDS = {
    "one":   1,
    "two":   2,
    "three": 3,
    "four":  4,
    "five":  5,
    "six":   6,
    "seven": 7,
    "eight": 8,
    "nine":  9,
}

def digits_in_line(line: str) -> list[int]:
    found = []
    n = len(line)

    for i in range(n):
        ch = line[i]

        if ch.isdigit():
            found.append(int(ch))
            continue

        for word, value in WORDS.items():
            if line.startswith(word, i):
                found.append(value)
                break  # don’t need to check other words at this index

    return found


def solve_part_2(data):
    total = 0
    for line in data:
        digits = digits_in_line(line)
        total += digits[0] * 10 + digits[-1]
    return total

path = "Inputs/day-01.txt"
raw = read_input(path)
data = parse_file(raw)
#print("part 1: " + str(solve_part_1(data)))
print("part 2: " + str(solve_part_2(data)))
