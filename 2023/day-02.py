def read_input(path):
    with open(path) as f:
        return f.read()
    
def parse_file(raw):
    games = {}
    for line in raw.splitlines():
        temp = line.split(": ")

        _game_id = temp[0].split(" ")
        game_id = int(_game_id[1])

        _matches = temp[1].split("; ")
        match_array = []
        for _match in _matches:
            _play = _match.split(", ")
            play_array = []

            for _cubes in _play:
                num, color = _cubes.split(" ")
                play_array.append([int(num), color])
            match_array.append(play_array)
        games[game_id] = match_array
    return games

def solve_part1(games):
    game_data = {"red": 12, "green": 13, "blue": 14}
    total = 0

    for key, value in games.items():
        used = {"red": 0, "green": 0, "blue": 0}
        valid = True
        for round in value:
            for play in round:
                used[play[1]] += play[0]
                if game_data[play[1]] < play[0]:
                    valid = False
                    break
        if valid:
            total += key

    return total

def solve_part2(games):
    total = 0

    for key, value in games.items():
        used = {"red": None, "green": None, "blue": None}
        for round in value:
            for play in round:
                if used[play[1]] == None or used[play[1]] < play[0]:
                    used[play[1]] = play[0]

        total += used["red"] * used["blue"] * used["green"]

    return total


path = "Inputs/day-02.txt"
raw = read_input(path)
data = parse_file(raw)
print("part 1: " + str(solve_part1(data)))
print("part 2: " + str(solve_part2(data)))