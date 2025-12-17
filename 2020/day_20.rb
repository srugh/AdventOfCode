# frozen_string_literal: true

# ---------- parsing ----------
def parse_tiles(path)
  File.read(path).split("\n\n").to_h do |chunk|
    lines = chunk.lines.map!(&:chomp)
    id = lines.shift[/\d+/].to_i
    [id, lines]
  end
end

# ---------- grid ops ----------
# 90° CW
def rotate(grid)
  n = grid.size
  (0...n).map { |c| (n - 1).downto(0).map { |r| grid[r][c] }.join }
end

# horizontal mirror
def flip_h(grid)
  grid.map(&:reverse)
end

def orientations(grid)
  rots = [grid]
  3.times { rots << rotate(rots.last) }
  all = rots + rots.map { |g| flip_h(g) }
  # 8 unique orientations
  all.uniq
end

def edges(grid)
  top    = grid.first
  bottom = grid.last
  left   = grid.map { |r| r[0] }.join
  right  = grid.map { |r| r[-1] }.join
  [top, right, bottom, left]
end

# ---------- backtracking placement ----------
def assemble(tiles)
  ntiles = tiles.size
  n = Math.sqrt(ntiles).to_i
  raise 'not square' unless n * n == ntiles

  # Precompute orientations per tile: id -> [{grid:, edges:}]
  variants = {}
  tiles.each do |id, grid|
    variants[id] = orientations(grid).map { |g| { grid: g, edges: edges(g) } }
  end

  placed = Array.new(n) { Array.new(n) } # each cell: {id:, grid:, edges:}
  used   = {} # id -> true

  north_ok = lambda { |r, c, e_top|
    return true if r.zero?

    placed[r - 1][c][:edges][2] == e_top # neighbor south == my top
  }
  west_ok = lambda { |r, c, e_left|
    return true if c.zero?

    placed[r][c - 1][:edges][1] == e_left # neighbor east == my left
  }

  ids = tiles.keys

  solve = lambda do |pos|
    return true if pos == n * n

    r = pos / n
    c = pos % n
    ids.each do |id|
      next if used[id]

      variants[id].each do |v|
        top, _, _, left = v[:edges]
        next unless north_ok.call(r, c, top)
        next unless west_ok.call(r, c, left)

        placed[r][c] = { id: id, grid: v[:grid], edges: v[:edges] }
        used[id] = true
        return true if solve.call(pos + 1)

        used.delete(id)
        placed[r][c] = nil
      end
    end
    false
  end

  ok = solve.call(0)
  raise 'no arrangement found' unless ok

  placed
end

# ---------- stitch full image (strip borders) ----------
def strip_borders(grid)
  inner_rows = grid[1...-1]
  inner_rows.map { |row| row[1...-1] }
end

def stitch_image(placed)
  n = placed.size
  tile_inner = strip_borders(placed[0][0][:grid])
  t = tile_inner.size # inner tile height
  tile_inner.first.size # inner tile width

  rows = []
  (0...n).each do |tr|
    (0...t).each do |ir|
      row = ''
      (0...n).each do |tc|
        row << strip_borders(placed[tr][tc][:grid])[ir]
      end
      rows << row
    end
  end
  rows
end

# ---------- sea monster detection ----------
MONSTER = [
  '                  # ',
  '#    ##    ##    ###',
  ' #  #  #  #  #  #   '
].freeze
MONSTER_OFFSETS = begin
  off = []
  MONSTER.each_with_index do |row, r|
    row.chars.each_with_index { |ch, c| off << [r, c] if ch == '#' }
  end
  off
end
MONSTER_H = MONSTER.size
MONSTER_W = MONSTER.first.size
MONSTER_COUNT_HASH = MONSTER_OFFSETS.size

def count_hashes(grid)
  grid.sum { |row| row.count('#') }
end

def count_monsters(grid)
  h = grid.size
  w = grid.first.size
  count = 0
  (0..(h - MONSTER_H)).each do |r|
    (0..(w - MONSTER_W)).each do |c|
      ok = MONSTER_OFFSETS.all? { |dr, dc| grid[r + dr][c + dc] == '#' }
      count += 1 if ok
    end
  end
  count
end

def roughness_after_monsters(full_grid)
  total_hash = count_hashes(full_grid)
  orientations(full_grid).each do |g|
    m = count_monsters(g)
    return total_hash - (m * MONSTER_COUNT_HASH) if m.positive?
  end
  raise 'no monsters found'
end

path = 'Inputs/day-20.txt'
tiles = parse_tiles(path)
placed = assemble(tiles)
full = stitch_image(placed)
puts roughness_after_monsters(full)
