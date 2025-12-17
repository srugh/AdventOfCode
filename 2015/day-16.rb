# frozen_string_literal: true

def parse_input(input_file)
  aunts = {}
  File.foreach(input_file) do |line|
    things = {}

    temp = line.chomp.split(',')
    x = temp[0].strip.split(':')

    sue = x[0].split[1].to_i
    first = [x[1].strip, x[2]]
    second = temp[1].strip.split(':')
    third = temp[2].strip.split(':')

    second[1] = second[1].to_i
    third[1] = third[1].to_i

    things[first[0]] = first[1].to_i
    things[second[0]] = second[1].to_i
    things[third[0]] = third[1].to_i

    aunts[sue] = things
  end
  aunts
end

def find_aunt(aunts, criteria)
  eliminated = Set.new
  possible = Set.new
  aunts.each do |aunt, things|
    possible.add(aunt)
    things.each do |thing, count|
      if criteria.include?(thing)
        if %w[cats trees].include?(thing)
          if count <= criteria[thing]
            puts "Aunt: #{aunt} eliminated, #{thing} criteria: #{criteria[thing]} aunt: #{count}"
            eliminated.add(aunt)
            possible.delete(aunt)
            break
          end
        elsif %w[pomeranians goldfish].include?(thing)
          if count >= criteria[thing]
            puts "Aunt: #{aunt} eliminated, #{thing} criteria: #{criteria[thing]} aunt: #{count}"
            eliminated.add(aunt)
            possible.delete(aunt)
            break
          end
        elsif criteria[thing] != count
          puts "Aunt: #{aunt} eliminated, #{thing} criteria: #{criteria[thing]} aunt: #{count}"
          eliminated.add(aunt)
          possible.delete(aunt)
          break
        end
      end
    end
  end
  puts eliminated.size
  puts possible.size

  possible
end

input = 'Inputs/day-16.txt'
criteria = {}

aunts = parse_input(input)
criteria['children'] = 3
criteria['cats'] = 7
criteria['samoyeds'] = 2
criteria['pomeranians'] = 3
criteria['akitas'] = 0
criteria['vizslas'] = 0
criteria['goldfish'] = 5
criteria['trees'] = 3
criteria['cars'] = 2
criteria['perfumes'] = 1

aunt = find_aunt(aunts, criteria)
puts "aunt: #{aunt}"
