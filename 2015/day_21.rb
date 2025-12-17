# frozen_string_literal: true

def solve_part1
  enemy = {}
  enemy['hp'] = 104
  enemy['dmg'] = 8
  enemy['armor'] = 1

  player = {}
  player['hp'] = 100
  player['dmg'] = 0
  player['armor'] = 0

  # gold, damage, armor
  weapons = {}
  weapons['dagger']     = [8, 4, 0]
  weapons['shortsword'] = [10, 5, 0]
  weapons['warhammer']  = [25, 6, 0]
  weapons['longsword']  = [40, 7, 0]
  weapons['greataxe']   = [74, 8, 0]

  armor = {}
  armor['leather']    = [13, 0, 1]
  armor['chainmail']  = [31, 0, 2]
  armor['splintmail'] = [53, 0, 3]
  armor['bandedmail'] = [75, 0, 4]
  armor['platemail']  = [102, 0, 5]
  armor['none']       = [0, 0, 0]

  rings = {}
  rings['damage_1']  = [25, 1, 0]
  rings['damage_2']  = [50, 2, 0]
  rings['damage_3']  = [100, 3, 0]
  rings['defense_1'] = [20, 0, 1]
  rings['defense_2'] = [40, 0, 2]
  rings['defense_3'] = [80, 0, 3]
  rings['none_1']    = [0, 0, 0]
  rings['none_2']    = [0, 0, 0]

  # requirements
  # 1 weapon
  w = weapons.keys

  # 1 armor (0 == none armor)
  a = armor.keys

  # 2 rings (0 & 1 == none_1 or none_2)
  r = rings.keys.combination(2).map do |perm|
    perm
  end

  w_set = [w, a, r]

  combinations = w_set.shift.product(*w_set)
  costly_win = -Float::INFINITY
  losses = 0
  combinations.each do |combo|
    player['hp'] = 100
    player['armor'] = 0
    player['dmg'] = 0
    enemy['hp'] = 104

    dmg_rings = %w[damage_1 damage_2 damage_3]

    c_w = combo[0]
    c_a = combo[1]
    c_r1 = combo[2].first
    c_r2 = combo[2].last
    r1_type = dmg_rings.include?(c_r1) ? 'dmg' : armor
    r2_type = dmg_rings.include?(c_r2) ? 'dmg' : armor

    player['dmg'] += weapons[c_w][1]
    player['armor'] += armor[c_a][2]
    if r1_type == 'dmg'
      player['dmg'] += rings[c_r1][1]
    else
      player['armor'] += rings[c_r1][2]
    end
    if r2_type == 'dmg'
      player['dmg'] += rings[c_r2][1]
    else
      player['armor'] += rings[c_r2][2]
    end

    cost = weapons[c_w][0] + armor[c_a][0] + rings[c_r1][0] + rings[c_r2][0]
    # next if cost < costly_win

    players_turn = true

    while enemy['hp'].positive? && player['hp'].positive?
      if players_turn
        enemy['hp'] -= [player['dmg'] - enemy['armor'], 1].max
      else
        player['hp'] -= [enemy['dmg'] - player['armor'], 1].max
      end
      players_turn = !players_turn
    end

    losses += 1 if enemy['hp'].positive?
    if enemy['hp'].positive? && cost > costly_win
      costly_win = cost
      p combo
    end
  end

  puts costly_win
  puts losses
end

solve_part1
