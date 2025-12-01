
$CARD_VALUES = {
  "A" => 14,
  "K" => 13,
  "Q" => 12,
  "J" => 11,
  "T" => 10,
}
2.upto(9) do |i|
  $CARD_VALUES[i.to_s] = i
end

$HAND_VALUES = {
  "AAAAA" => 7,
  "AAAA" => 6,
  "AAAKK" => 5,
  "AAA" => 4,
  "AAKK" => 3,
  "AA" => 2,
  "A" => 1,
}


$CARD_VALUES_2 = {
  "A" => 14,
  "K" => 13,
  "Q" => 12,
  "J" => 0,
  "T" => 10,
}
2.upto(9) do |i|
  $CARD_VALUES_2[i.to_s] = i
end


def parse_file(path)
  hands = Hash.new {|hash, key| hash[key] = {}}
  File.read(path).split(/\n/).map{|str| str.split}.each_with_index do |line, idx|
    hand, bid = line
    hands[idx]["cards"] = hand
    hands[idx]["bid"] = bid.to_i
  end
  hands
end

def solve_part_1(hands)
  score = 0

  hands.each do |k, v|
 
    cards, bid = v["cards"], v["bid"]
    unique_vals = cards.chars.uniq
    card_counts = {}

    unique_vals.each do |c|
      card_counts[c] = cards.count(c)
    end
    c_vals = []
    cards.chars.each do |c|
      c_vals.push($CARD_VALUES[c])
    end
    hands[k]["card_values"] = c_vals
    sorted_counts = card_counts.sort_by { |key, value| -value }.to_h

    has_trips = false
    has_pair = false
    sorted_counts.each do |card, count|
      if count == 5
        hands[k]["hand"] = "AAAAA"
        break
      elsif count == 4
        hands[k]["hand"] = "AAAA"
        break
      elsif count == 2 && has_trips
        hands[k]["hand"] = "AAAKK"
        break
      elsif count == 3
        has_trips = true
      elsif count == 2 && has_pair
        hands[k]["hand"] = "AAKK"
        break
      elsif count == 2
        has_pair = true
      elsif count == 1 && !has_pair && !has_trips
        hands[k]["hand"] = "A"
        break
      end
    end
    if hands[k]["hand"] == nil && has_trips
      hands[k]["hand"] = "AAA"
    elsif hands[k]["hand"] == nil && has_pair
      hands[k]["hand"] = "AA"
    end
    hands[k]["hand_value"] = $HAND_VALUES[hands[k]["hand"]]
  end


  sorted_multi_criteria = hands.sort_by do |name, data|
    [data["hand_value"], data["card_values"][0], data["card_values"][1], data["card_values"][2], data["card_values"][3], data["card_values"][4]]
  end.to_h

  sorted_multi_criteria.each_with_index do |(key, vals), rank|
    score += vals["bid"] * (rank+1)
  end

  score
end

def solve_part_2(hands)
  score = 0

  hands.each do |k, v|
 
    cards, bid = v["cards"], v["bid"]
    unique_vals = cards.chars.uniq
    card_counts = {}

    unique_vals.each do |c|
      card_counts[c] = cards.count(c)
    end
    c_vals = []
    cards.chars.each do |c|
      c_vals.push($CARD_VALUES_2[c])
    end
    hands[k]["card_values"] = c_vals
    sorted_counts = card_counts.sort_by { |key, value| -value }.to_h

    has_trips = false
    has_pair = false
    sorted_counts.each do |card, count|
      if count == 5
        hands[k]["hand"] = "AAAAA"
        break
      elsif count == 4
        hands[k]["hand"] = "AAAA"
        break
      elsif count == 2 && has_trips
        hands[k]["hand"] = "AAAKK"
        break
      elsif count == 3
        has_trips = true
      elsif count == 2 && has_pair
        hands[k]["hand"] = "AAKK"
        break
      elsif count == 2
        has_pair = true
      elsif count == 1 && !has_pair && !has_trips
        hands[k]["hand"] = "A"
        break
      end
    end
    if hands[k]["hand"] == nil && has_trips
      hands[k]["hand"] = "AAA"
    elsif hands[k]["hand"] == nil && has_pair
      hands[k]["hand"] = "AA"
    end

    jacks_count = cards.count("J")
    hand = hands[k]["hand"]
    case jacks_count
    when 1
      if hand == "A"
        hands[k]["hand"] = "AA"
      elsif hand == "AA"
        hands[k]["hand"] = "AAA"
      elsif hand == "AAKK"
        hands[k]["hand"] = "AAAKK"
      elsif hand == "AAA"
        hands[k]["hand"] = "AAAA"
      elsif hand == "AAAA"
        hands[k]["hand"] = "AAAAA"
      end
    when 2
      if hand == "AA"
        hands[k]["hand"] = "AAA"
      elsif hand == "AAAKK"
        hands[k]["hand"] = "AAAAA"
      elsif hand == "AAKK"
        hands[k]["hand"] = "AAAA"
      end
    when 3
      if hand == "AAA"
        hands[k]["hand"] = "AAAA"
      elsif hand == "AAAKK"
        hands[k]["hand"] = "AAAAA"
      end
    when 4
      hands[k]["hand"] = "AAAAA"
    end
    

    hands[k]["hand_value"] = $HAND_VALUES[hands[k]["hand"]]

  end



  sorted_multi_criteria = hands.sort_by do |name, data|
    [data["hand_value"], data["card_values"][0], data["card_values"][1], data["card_values"][2], data["card_values"][3], data["card_values"][4]]
  end.to_h

  sorted_multi_criteria.each_with_index do |(key, vals), rank|
    p hands[key] if vals["cards"].count("J") > 0
    
  end
  sorted_multi_criteria.each_with_index do |(key, vals), rank|
    score += vals["bid"] * (rank+1)
  end

  score
end

path = "Inputs/day-07.txt"
input = parse_file(path)
#puts "part_1: #{solve_part_1(input)}"
puts "part_2: #{solve_part_2(input)}"