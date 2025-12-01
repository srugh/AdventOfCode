def parse_input(path)
    ingredients = Hash.new
    File.readlines(path, chomp: true).each do |line|
      l, r = line.split(": ")
      c = r.split
      
      #ingredients[l] = [c[1].to_i, c[3].to_i, c[5].to_i, c[7].to_i, c[9].to_i]
      ingredients[l] = [c[1].to_i, c[3].to_i, c[5].to_i, c[7].to_i]

    end
    ingredients
end

def parse_input_2(path)
    ingredients = Hash.new
    calories = Hash.new
    File.readlines(path, chomp: true).each do |line|
      l, r = line.split(": ")
      c = r.split
      
      
      ingredients[l] = [c[1].to_i, c[3].to_i, c[5].to_i, c[7].to_i]
      calories[l] = c[9].to_i

    end
    [ingredients, calories]
end

def solve_part_1(ingredients)
  teaspoons = 100

  ingredient_count = ingredients.size

  best = -Float::INFINITY
  0.upto(teaspoons) do |t0|
    0.upto(teaspoons-t0) do |t1|
      0.upto(teaspoons-t0-t1) do |t2|
        t3 = teaspoons - t0 - t1 - t2
        ts = [t0, t1, t2, t3]
    
        sums = []
        ingredients.each_with_index do |(k, v), idx|
          
          sums.push([ts[idx]*v[0], ts[idx]*v[1], ts[idx]*v[2], ts[idx]*v[3]]) 
     
        end
        
        #p sums
        flip = Array.new(4) { Array.new(4,0) }

        sums.size.times do |i|
          sums[0].size.times do |j|
            flip[j][i] = sums[i][j]
          end
        end
 
        props = 4.times.map { |i| [flip[i].sum, 0].max }  
        score = props.inject(1, :*)
        best = [best, score].max
      end
    end
  end
  best
end

def solve_part_2(ingredients, calories)
  teaspoons = 100

  ingredient_count = ingredients.size

  best = -Float::INFINITY
  0.upto(teaspoons) do |t0|
    0.upto(teaspoons-t0) do |t1|
      0.upto(teaspoons-t0-t1) do |t2|
        t3 = teaspoons - t0 - t1 - t2
        ts = [t0, t1, t2, t3]
    
        sums = []
        ingredients.each_with_index do |(k, v), idx|
          
          sums.push([ts[idx]*v[0], ts[idx]*v[1], ts[idx]*v[2], ts[idx]*v[3]]) 
     
        end
        
        #p sums
        flip = Array.new(4) { Array.new(4,0) }

        sums.size.times do |i|
          sums[0].size.times do |j|
            flip[j][i] = sums[i][j]
          end
        end
 
        props = 4.times.map { |i| [flip[i].sum, 0].max }  
        cals = ts[0] * calories["Sugar"] + ts[1] * calories["Sprinkles"] + ts[2] * calories["Candy"] + ts[3] * calories["Chocolate"]
        score = props.inject(1, :*)
        best = [best, score].max if cals == 500
      end
    end
  end
  best
end

path = "Inputs/day-15.txt"
input = parse_input(path)
ing, cal = parse_input_2(path)
#part_1 = solve_part_1(input)
part_2 = solve_part_2(ing, cal)
puts "part_2: #{part_2}"