require 'set'
def parse_input(path)
  i = []
  a = []
  File.readlines(path, chomp:true).each do |line|
    parts = line.split(" (contains ")
    i.push(parts[0].split(" ").map {|c| c.chomp})
    a.push(parts[1].scan(/(\w+)/).flatten)
  end
  [i, a]
end


def solve_part_1(ingredients, allergens)
  allergens_hash = Hash.new
  ingredients_hash = Hash.new
  

  allergens.each_with_index do |as, idx|
    as.each do |a|
      if allergens_hash.key?(a)
        allergens_hash[a].push(idx)
      else
        allergens_hash[a] = [idx]
      end
    end
  end

  ingredients.each_with_index do |food, idx|
    food.each do |ingredient|
      if ingredients_hash.key?(ingredient)
        ingredients_hash[ingredient].push(idx)
      else
        ingredients_hash[ingredient] = [idx]
      end
    end
  end

#p allergens_hash
#p ingredients_hash
#p i_to_a
#p a_to_i

p ingredients
#p allergens
candidates = Hash.new
c_set = Set.new
  allergens_hash.each do |k, v|
    ings = []
    
    v.each do |food|
      
      ings.push(ingredients[food])
    end
    candidates[k] = ings.inject(:&) 
  end
p candidates

candidates.each do |k, v|
  v.each do |i|
    c_set.add(i)
  end
end

  ing_set = Set.new
  ing_counts = Hash.new
  ingredients.each do |ing|
    ing.each do |i|
      ing_set.add(i)
      if ing_counts.key?(i)
          ing_counts[i] += 1
      else
          ing_counts[i] = 1
      end
    end
  end
p ing_set

  safe = ing_set - c_set

  p safe

  part_1 = 0
  safe.each do |i|
    part_1 += ing_counts[i]
  end



  known_links = Hash.new
  cand_dup = candidates.dup
  while candidates.size > 0
    candidates.each do |k, v|
      puts "k: #{k}, v: #{v}"
      p known_links
      if v.size == 1
        puts "deleting"
        puts k
        known_links[k] = v[0]
        candidates.delete(k)

        candidates.each do |k2,v2|
          puts k2
          p v2
          p v
          if v2.include?(v[0])
            puts "here"
            candidates[k2].delete(v[0])
          end
        end
        
      end
    end
  end
  sorted_hash = known_links.sort_by { |key, value| key }.to_h

  bad_string = ""
  sorted_hash.each do |k, v|
    bad_string += v
    bad_string += ","
  end
  bad_string[bad_string.size-1] = ""
  p bad_string
end
path = "Inputs/day-21.txt"
#path = "Inputs/day-21-sample.txt"
ingredients, allergens = parse_input(path)
part_1 = solve_part_1(ingredients, allergens)

puts "part 1: #{part_1}"
