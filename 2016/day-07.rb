require 'set'
def parse_input(path)
  File.read(path).split(/\n/)
end

def solve_part_1(input)
  bad = Set.new
  good = Set.new

  input.each do |s|

    s.scan(/\[(\w{4,})\]/).each do |ht|
      ht = ht.first
      0.upto(ht.size-4) do |i|
        cs = ht[i,4]
        bad.add(s) if is_abba(cs)
      end
    end

    next if bad.include?(s)
    0.upto(s.size-4) do |i|
      cs = s[i,4]
      good.add(s) if is_abba(cs)
    end

  end
  good.size
end

def solve_part_2(input)
  good = Set.new

  #input = ["xyx[xyx]xyx"]
  input.each do |s|
    abas = Set.new
    htABAs = Set.new
 
    # find ABAs inside hypernet []
    s.scan(/\[(\w{3,})\]/).each do |ht|
      ht = ht.first
      0.upto(ht.size-2) do |i|
        cs = ht[i,3]
        htABAs.add(cs) if is_aba(cs)
      end
    end

    # find ABAs not within hypernet
    s.split(/\[[a-z]+\]/).each do |sn|
      0.upto(sn.size - 3) do |i|
        cs = sn[i,3]
        abas.add(cs) if is_aba(cs)
      end
    end
 
    # check if ABA has corresponding BAB in hypernet 
    abas.each do |aba|
      bab = aba[1] + aba[0] + aba[1]
      good.add(s) if htABAs.include?(bab)
    end
  end
  good.size
end

def is_abba(str)
  return false if str.size != 4
  c_1 = true if str[0] == str[3]
  c_2 = true if str[1] == str[2]
  c_3 = true if str[0] != str[1]

  c_1 && c_2 && c_3
end

def is_aba(str)
  return false if str.size != 3
  c_1 = true if str[0] == str[2]
  c_2 = true if str[0] != str[1]

  c_1 && c_2
end

path = "Inputs/day-07.txt"
input = parse_input(path)
p solve_part_1(input)
p solve_part_2(input)