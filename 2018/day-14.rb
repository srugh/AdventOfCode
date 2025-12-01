

def find_next_10(after, rec_1, rec_2)
    recipes =[]
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

        elf_1 = (elf_1 + (recipes[elf_1]+ 1)) % recipes.size
        elf_2 = (elf_2 + (recipes[elf_2]+ 1)) % recipes.size

        #p recipes
    end
    recipes[after..after+9].join

end


def calc_recipes(before, rec_1, rec_2)
    recipes =[]
    recipes_created = 0
    recipes.push(rec_1)
    recipes.push(rec_2)

    elf_1 = 0
    elf_2 = 1

    target = before.to_s.chars.map(&:to_i)
    target_length = target.length

    while true
        if recipes_created % 10_000 == 0
            puts "#{recipes_created}"
        end
        sum = recipes[elf_1] + recipes[elf_2]
        if sum >= 10
            recipes.push(1)
            recipes_created += 1
            if recipes.size > 5
                #puts recipes[recipes.size-6..recipes.size-1].join
                #puts before
                if recipes[-target_length..-1] == target
                    puts "WINNER"
                    return recipes.size - target_length
                end
            end
        end
        recipes.push(sum % 10)
        recipes_created += 1

        elf_1 = (elf_1 + (recipes[elf_1]+ 1)) % recipes.size
        elf_2 = (elf_2 + (recipes[elf_2]+ 1)) % recipes.size

        #p recipes
        if recipes.size > 5
            #puts recipes[recipes.size-6..recipes.size-1].join
            #puts before
            if recipes[-target_length..-1] == target
                puts "WINNER"
                return recipes.size - target_length
            end
        end
    end

end


input = 5 #0124515891
input = 9 #5158916779
input = 18 #9251071085
input = 2018 #5941429882
input = 894501

input_2 = 51589 #9
#input_2 = 01245 #5
input_2 = 92510 #18
input_2 = 59414 #2018
#input_2 = 894501


rec_1 = 3
rec_2 = 7
#part_1 = find_next_10(input, rec_1, rec_2)

puts input_2
part_2 = calc_recipes(input_2, rec_1, rec_2)

puts "answer: #{part_2}"