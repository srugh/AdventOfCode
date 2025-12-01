def parse_file(path)
    cards = Hash.new{|hash,key| hash[key] = {}}
    File.readlines(path).each do |line|
        card, numbers = line.split(": ")
        card_id = card.split()[1].to_i
        
        winning, candidates = numbers.split(" | ").map{|str| str.split().map{|i| i.to_i}}

        cards[card_id]["winning"] = winning
        cards[card_id]["candidates"] = candidates
        cards[card_id]["winners"] = 0
        cards[card_id]["copies"] = 0
    end
    cards
end

def solve_part_1(cards)
    score = 0
    cards.each do |id, v|
        winners = 0
        winning, candidates = v["winning"], v["candidates"]
        candidates.each do |num|
            winners += 1 if winning.include?(num)
        end
        score += winners == 0 ? 0 : 2**(winners-1)
    end
    score
end

def solve_part_2(cards)
    remaining = 1
    count = 1
    cards.each do |id, v|
        winning, candidates = v["winning"], v["candidates"]

        candidates.each do |num|
            cards[id]["winners"] += 1 if winning.include?(num)
        end

        next if cards[id]["winners"] == 0

        1.upto(cards[id]["winners"])  do |i|
            cards[id+i]["copies"] += 1 + cards[id]["copies"]
        end
    end

    total_cards = 0
    cards.each do |k, v|
        puts "#{k}: #{v["copies"]}"
        total_cards += v["copies"] + 1
    end

    total_cards
end

path = "Inputs/day-04.txt"
input = parse_file(path)
puts "part_1: #{solve_part_1(input)}"
puts "part_2: #{solve_part_2(input)}"