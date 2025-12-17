# frozen_string_literal: true

def solve_part1(input, total_rows)
  total_safe = 0
  safe = '.'
  seen = Set.new
  seen_info = Hash.new { |hash, key| hash[key] = {} }
  total_safe += input.count(safe)
  prev = input

  (total_rows - 1).times do |j|
    p j if (j % 20_000).zero?
    # if seen.include?(prev)

    #   total_safe += seen_info[prev]["safe_score"]
    #   prev = seen_info[prev]["next"]
    #   next

    # end

    if seen.include?(prev)
      info = seen_info[prev]
      total_safe += info['safe_score']
      prev = info['next'] # previously-computed next row
      next
    end

    cur = ''
    0.upto(input.length - 1) do |i|
      _ = ''
      l = (i - 1).negative? || prev[i - 1] == '.' ? '.' : '^'
      c = prev[i]
      r = i + 1 > input.length - 1 || prev[i + 1] == '.' ? '.' : '^'
      cur += is_trap(l, c, r) ? '^' : '.'
    end

    seen.add(prev)
    seen_info[prev]['safe_score'] = cur.count('.')
    seen_info[prev]['next'] = cur

    total_safe += cur.count('.')
    prev = cur
  end
  total_safe
end

def is_trap(l, c, r)
  (l == '^' && c == '^' && r == '.') ||
    (l == '.' && c == '^' && r == '^') ||
    (l == '^' && c == '.' && r == '.') ||
    (l == '.' && c == '.' && r == '^')
end

input = '.^..^....^....^^.^^.^.^^.^.....^.^..^...^^^^^^.^^^^.^.^^^^^^^.^^^^^..^.^^^.^^..^.^^.^....^.^...^^.^.'

total_rows_part_2 = 400_000
p solve_part1(input, total_rows_part_2)
