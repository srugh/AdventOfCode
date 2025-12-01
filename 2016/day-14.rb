require "digest"

# Compute hash for (salt + index), with optional extra stretching.
# extra_stretch = 0  => plain MD5 (Part 1)
# extra_stretch = 2016 => 2017 total MD5 calls (Part 2)
def stretched_hash(salt, index, extra_stretch)
  h = Digest::MD5.hexdigest("#{salt}#{index}")
  extra_stretch.times do
    h = Digest::MD5.hexdigest(h)
  end
  h
end

def find_64th_key_index(salt, extra_stretch: 0)
  cache = {}

  get_hash = lambda do |i|
    cache[i] ||= stretched_hash(salt, i, extra_stretch)
  end

  keys = []
  i = 0

  while keys.size < 64
    h = get_hash.call(i)

    # Find first triplet (aaa, 777, etc)
    if h =~ /(.)\1\1/
      ch = $1
      five = ch * 5

      # Look ahead 1000 hashes for ch * 5
      found = (i + 1 .. i + 1000).any? do |j|
        get_hash.call(j).include?(five)
      end

      keys << i if found
    end

    i += 1
  end

  keys.last
end

# --- main ---
salt = "ngcjuoqr"

part1 = find_64th_key_index(salt, extra_stretch: 0)
part2 = find_64th_key_index(salt, extra_stretch: 2016)

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"