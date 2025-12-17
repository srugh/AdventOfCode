# frozen_string_literal: true

def checksum(steps)
  ones = Set.new
  pos = 0
  state = :a

  steps.times do
    cur1 = ones.include?(pos)

    case state
    when :a
      if cur1
        ones.delete(pos)
        pos -= 1
        state = :d
      else
        ones.add(pos)
        pos += 1
        state = :b
      end
    when :b
      if cur1
        ones.delete(pos)
        pos += 1
        state = :f
      else
        ones.add(pos)
        pos += 1
        state = :c
      end
    when :c
      if cur1
        pos -= 1
        state = :a
      else
        ones.add(pos)
        pos -= 1
        state = :c
      end
    when :d
      if cur1
        pos += 1
        state = :a
      else
        pos -= 1
        state = :e
      end
    when :e
      if cur1
        ones.delete(pos)
        pos += 1
        state = :b
      else
        ones.add(pos)
        pos -= 1
        state = :a
      end
    when :f
      if cur1
        ones.delete(pos)
        pos += 1
        state = :e
      else
        pos += 1
        state = :c
      end
    end
  end

  ones.length
end

steps = 12_317_297
puts "part 1: #{checksum(steps)}"
