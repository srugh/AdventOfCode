def parse_file(path)
  mappings = Hash.new
  seeds = Hash.new { |hash, key| hash[key] = {}}
  chunks = File.read(path).split(/\n\n/).map{ |str| str.split(/\n/) }

  chunks.shift.last.split(": ")[1].split().map {|i| i.to_i}.each do |seed|
    seeds[seed]
  end

  temp = chunks.shift
  temp.shift
  mappings["seed_to_soil"] = temp.map{|str| str.split().map{|i| i.to_i}}


  temp = chunks.shift
  temp.shift
  mappings["soil_to_fertilizer"] = temp.map{|str| str.split().map{|i| i.to_i}}

  temp = chunks.shift
  temp.shift
  mappings["fertilizer_to_water"] = temp.map{|str| str.split().map{|i| i.to_i}}

  temp = chunks.shift
  temp.shift
  mappings["water_to_light"] = temp.map{|str| str.split().map{|i| i.to_i}}

  temp = chunks.shift
  temp.shift
  mappings["light_to_temp"] = temp.map{|str| str.split().map{|i| i.to_i}}

  temp = chunks.shift
  temp.shift
  mappings["temp_to_humidity"] = temp.map{|str| str.split().map{|i| i.to_i}}

  temp = chunks.shift
  temp.shift
  mappings["humidity_to_location"] = temp.map{|str| str.split().map{|i| i.to_i}}

  seeds.each do |k, v|
    mappings.keys.each do |key|
      seeds[k][key] = nil
    end
  end
  [seeds, mappings]

end

def solve_part_1(input)
  seeds, mappings = input
  mappings_list = mappings.keys

  seeds.each do |id, val|
    mappings.each_with_index do |(m_name, mapping), m_idx|
      mapping.each do |lookup|
        if m_idx > 0
          if seeds[id][mappings_list[m_idx-1]] >= lookup[1] && seeds[id][mappings_list[m_idx-1]] < lookup[1] + lookup[2]
            seeds[id][m_name] = seeds[id][mappings_list[m_idx-1]]  - lookup[1] + lookup[0]
            break
          end
        else
          seeds[id][m_name] = id
          if id >= lookup[1] && id < lookup[1] + lookup[2]
            seeds[id][m_name] = id - lookup[1] + lookup[0]
            break
          end
        end
      end
      seeds[id][m_name] = seeds[id][mappings_list[m_idx-1]] if seeds[id][mappings_list[m_idx]] == nil
    end
  end


  str = "\tseed\t"
  mappings_list.each do |mapping|
    temp = mapping.split("_").last
    str += temp[0,4] + "\t"
  end
  puts str
  seeds.each do |k,v|
    str = "\t " + k.to_s + "\t"
    v.each do |key, val|
      str += val.to_s + "\t "
    end
    puts str
  end

  seeds.values.map { |inner_hash| inner_hash[mappings_list.last] }.min
end

path = "Inputs/day-05.txt"
#path = "Inputs/day-05-sample.txt"
input = parse_file(path)

puts "part_1 #{solve_part_1(input)}"
