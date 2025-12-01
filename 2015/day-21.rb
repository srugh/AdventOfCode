
def solve_part_1()
  enemy = Hash.new
  enemy["hp"], enemy["dmg"], enemy["armor"] = [104, 8, 1]

  player = Hash.new
  player["hp"], player["dmg"], player["armor"] = [100, 0, 0]

  # gold, damage, armor
  weapons = Hash.new
  weapons["dagger"]     = [8, 4, 0]
  weapons["shortsword"] = [10, 5, 0]
  weapons["warhammer"]  = [25, 6, 0]
  weapons["longsword"]  = [40, 7, 0]
  weapons["greataxe"]   = [74, 8, 0]

  armor = Hash.new
  armor["leather"]    = [13, 0, 1]
  armor["chainmail"]  = [31, 0, 2]
  armor["splintmail"] = [53, 0, 3]
  armor["bandedmail"] = [75, 0, 4]
  armor["platemail"]  = [102, 0, 5]
  armor["none"]       = [0, 0, 0]

  rings = Hash.new
  rings["damage_1"]  = [25, 1, 0]
  rings["damage_2"]  = [50, 2, 0]
  rings["damage_3"]  = [100, 3, 0]
  rings["defense_1"] = [20, 0, 1]
  rings["defense_2"] = [40, 0, 2]
  rings["defense_3"] = [80, 0, 3]
  rings["none_1"]    = [0, 0, 0]
  rings["none_2"]    = [0, 0, 0]

  # requirements
  # 1 weapon
  w = weapons.keys

  # 1 armor (0 == none armor)
  a = armor.keys

  # 2 rings (0 & 1 == none_1 or none_2)
  r = []
  rings.keys.combination(2).each do |perm| 
    r.push(perm) 
  end

  w_set = [w, a, r]

  combinations = w_set.shift.product(*w_set)

  cheapest_win = Float::INFINITY
  costly_win = -Float::INFINITY

  wins = 0
  losses = 0
  combinations.each do |combo|
    player["hp"] = 100
    player["armor"] = 0
    player["dmg"] = 0
    enemy["hp"] = 104

    dmg_rings = ["damage_1", "damage_2", "damage_3"]

    c_w, c_a, c_r1, c_r2 = combo[0], combo[1], combo[2].first, combo[2].last
    r1_type = dmg_rings.include?(c_r1) ? "dmg" : armor  
    r2_type = dmg_rings.include?(c_r2) ? "dmg" : armor   

    player["dmg"] += weapons[c_w][1]
    player["armor"] += armor[c_a][2]
    if r1_type == "dmg"
      player["dmg"] += rings[c_r1][1]
    else
      player["armor"] += rings[c_r1][2]
    end
    if r2_type == "dmg"
      player["dmg"] += rings[c_r2][1]
    else
      player["armor"] += rings[c_r2][2]
    end

    cost = weapons[c_w][0] + armor[c_a][0] + rings[c_r1][0] + rings[c_r2][0] 
    #next if cost < costly_win


    players_turn = true

 
    while enemy["hp"] > 0 && player["hp"] > 0
      if players_turn
        enemy["hp"] -= player["dmg"] - enemy["armor"] > 1 ? player["dmg"] - enemy["armor"]  : 1
      else
        player["hp"] -= enemy["dmg"] - player["armor"] > 1 ? enemy["dmg"] - player["armor"]  : 1
      end
      players_turn = !players_turn
    end


    losses += 1 if enemy["hp"] > 0
    if enemy["hp"] > 0 && cost > costly_win
      costly_win = cost 
      p combo
    end

   
  end

puts costly_win
puts losses

end

solve_part_1