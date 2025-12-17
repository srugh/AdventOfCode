# frozen_string_literal: true

def find_next_10(after, rec_1, rec_2)
  recipes = []
  recipes_created = 0
  recipes.push(rec_1)
  recipes.push(rec_2)

  elf_1 = 0
  elf_2 = 1

  while recipes_created < after + 10
    sum = recipes[elf_1] + recipes[elf_2]
    if sum >= 10
      recipes.push(1)
      recipes_created += 1
    end
    recipes.push(sum % 10)
    recipes_created += 1

    elf_1 = (elf_1 + (recipes[elf_1] + 1)) % recipes.size
    elf_2 = (elf_2 + (recipes[elf_2] + 1)) % recipes.size

    # p recipes
  end
  recipes[after..(after + 9)].join
end

def calc_recipes(before, rec_1, rec_2)
  recipes = []
  recipes_created = 0
  recipes.push(rec_1)
  recipes.push(rec_2)

  elf_1 = 0
  elf_2 = 1

  target = before.to_s.chars.map(&:to_i)
  target_length = target.length

  loop do
    puts recipes_created if (recipes_created % 10_000).zero?
    sum = recipes[elf_1] + recipes[elf_2]
    if sum >= 10
      recipes.push(1)
      recipes_created += 1
      # puts recipes[recipes.size-6..recipes.size-1].join
      # puts before
      if (recipes.size > 5) && (recipes[-target_length..] == target)
        puts 'WINNER'
        return recipes.size - target_length
      end
    end
    recipes.push(sum % 10)
    recipes_created += 1

    elf_1 = (elf_1 + (recipes[elf_1] + 1)) % recipes.size
    elf_2 = (elf_2 + (recipes[elf_2] + 1)) % recipes.size

    # p recipes
    next unless recipes.size > 5

    # puts recipes[recipes.size-6..recipes.size-1].join
    # puts before
    if recipes[-target_length..] == target
      puts 'WINNER'
      return recipes.size - target_length
    end
  end
end
# input_2 = 01245 #5 # 18
input_2 = 59_414 # 2018
# input_2 = 894501

rec_1 = 3
rec_2 = 7
# part_1 = find_next_10(input, rec_1, rec_2)

puts input_2
part_2 = calc_recipes(input_2, rec_1, rec_2)

puts "answer: #{part_2}"
