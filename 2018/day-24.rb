# frozen_string_literal: true

class Army
  attr_accessor :units, :hp, :final_target
  attr_reader :faction, :attack_damage, :attack_type, :initiative, :weaknesses, :immunities, :name

  def initialize(faction, units, hit_points, attack_damage, attack_type, initiative, weaknesses, immunities, name)
    @faction = faction
    @units = units
    @hp = hit_points
    @attack_damage = attack_damage
    @attack_type = attack_type
    @initiative = initiative
    @weaknesses = weaknesses
    @immunities = immunities
    @name = name
    @final_target = ''
    @targets = []
  end

  def effective_power
    @units * @attack_damage
  end

  def total_damage(weaknesses, immunities)
    multiplier = 1

    immunities.each do |immunity|
      return 0 if immunity == @attack_type
    end

    weaknesses.each do |weakness|
      multiplier = 2 if weakness == @attack_type
    end

    @units * @attack_damage * multiplier
  end

  def clear_targets
    @targets = []
  end

  def add_target(target, damage)
    @targets.nil? ? @targets = [target, damage] : @targets.push([target, damage])
  end

  def get_all_targets
    @targets
  end

  def get_best_target
    max_damage = 0
    index = 0
    @targets.each_with_index do |target, idx|
      _, damage = target
      if damage > max_damage
        max_damage = damage
        index = idx
      end
    end
    return @targets[index] if max_damage.positive?

    nil
  end

  def pretty_print
    puts "name: #{@name} \t faction: #{@faction} \t units: #{@units} \t hp: #{@hp} \t effective_power: #{effective_power} \t initiative: #{@initiative}"
    puts "attack_type: #{@attack_type} \t attack_damage: #{@attack_damage} \t weaknesses: #{@weaknesses} \t immunities: #{@immunities}"

    puts "all_targets: #{get_all_targets}"
    puts "max_attack: #{get_best_target}"
  end

  def attack_print
    puts "name: #{@name} \t effective_power: #{effective_power} \t initiative: #{@initiative}"
  end
end

def parse_input(input)
  immune = []
  infection = []

  parts = File.read(input).split("\n\n")
  pattern = /
  (?<units>\d+)\s+units\s+each\s+with\s+
  (?<hit_points>\d+)\s+hit\s+points
  (?:\s+\((?<traits>[^)]+)\))?
  \s+with\s+an\s+attack\s+that\s+does\s+
  (?<attack_damage>\d+)\s+
  (?<attack_type>\w+)\s+damage\s+at\s+initiative\s+
  (?<initiative>\d+)
  /x

  lines = parts[0].split("\n")

  lines.each do |line|
    match = line.match(pattern)
    units = match[:units].to_i
    hit_points = match[:hit_points].to_i
    attack_damage = match[:attack_damage].to_i
    attack_type = match[:attack_type]
    initiative = match[:initiative].to_i

    weaknesses = []
    immunities = []

    traits = match[:traits]
    if match[:traits]
      # Split traits by semicolon to separate weaknesses and immunities
      traits.split(';').each do |trait|
        trait.strip!

        if trait.start_with?('weak to')
          # Extract weaknesses, split by comma, and remove any extra whitespace
          weaknesses = trait.sub('weak to ', '').split(',').map(&:strip)
        elsif trait.start_with?('immune to')
          # Extract immunities, split by comma, and remove any extra whitespace
          immunities = trait.sub('immune to ', '').split(',').map(&:strip)
        end
      end
    end
    faction = 'immunity'
    name = "#{faction}_#{immune.size}"
    army = Army.new(faction, units, hit_points, attack_damage, attack_type, initiative, weaknesses, immunities,
                    name)
    immune.push(army)
  end

  lines = parts[1].split("\n")

  lines.each do |line|
    match = line.match(pattern)
    units = match[:units].to_i
    hit_points = match[:hit_points].to_i
    attack_damage = match[:attack_damage].to_i
    attack_type = match[:attack_type]
    initiative = match[:initiative].to_i

    weaknesses = []
    immunities = []

    traits = match[:traits]
    if match[:traits]
      # Split traits by semicolon to separate weaknesses and immunities
      traits.split(';').each do |trait|
        trait.strip!

        if trait.start_with?('weak to')
          # Extract weaknesses, split by comma, and remove any extra whitespace
          weaknesses = trait.sub('weak to ', '').split(',').map(&:strip)
        elsif trait.start_with?('immune to')
          # Extract immunities, split by comma, and remove any extra whitespace
          immunities = trait.sub('immune to ', '').split(',').map(&:strip)
        end
      end
    end
    faction = 'infection'
    name = "#{faction}_#{infection.size}"
    army = Army.new(faction, units, hit_points, attack_damage, attack_type, initiative, weaknesses, immunities,
                    name)
    infection.push(army)
  end
  [immune, infection]
end

def fight(immune_army, infection_army)
  while immune_army.size.positive? && infection_army.size.positive?
    immune_army, infection_army = target_phase(immune_army, infection_army)
    immune_army, infection_army = attack_phase(immune_army, infection_army)

    nil.push(thjb)
  end
end

def attack_phase(immune_army, infection_army)
  immune_army = immune_army.sort_by { |unit| [-unit.initiative] }
  infection_army = infection_army.sort_by { |unit| [-unit.initiative] }
  imm_idx = 0
  inf_idx = 0
  inf_remaining = true
  imm_remaining = true

  while imm_idx < immune_army.size && inf_idx < infection_army
    imm_remaining = false if imm_idx == immune_army.size
    inf_remaining = false if inf_idx == infection_army.size

    if imm_remaining && inf_remaining
      if immune_army[imm_idx].initiative > infection_army[inf_idx].initiative
        # immune attack

        imm_idx += 1
      else
        # infection attack

        inf_idx += 1
      end
    elsif imm_remaining && !inf_remaining
      # immune attack

      imm_idx += 1
    elsif !imm_remaining && inf_remaining
      # infection attack

      inf_idx += 1
    end
  end
end

def find_object_by_name(array, target_name)
  array.find { |obj| obj.name == target_name }
end

def target_phase(immune_army, infection_army)
  immune_army = immune_army.sort_by { |unit| [-unit.effective_power, -unit.initiative] }
  infection_army = infection_army.sort_by { |unit| [-unit.effective_power, -unit.initiative] }

  army_set = Set.new
  infection_army.each do |unit|
    army_set.add(unit.name)
  end

  immune_army.each_with_index do |imm_group, _idx|
    infection_army.each do |inf_group|
      if army_set.include?(inf_group.name)
        damage = imm_group.total_damage(inf_group.weaknesses, inf_group.immunities)
        imm_group.add_target(inf_group.name, damage)
      end
    end
    best_attack = imm_group.get_best_target
    imm_group.final_target = best_attack[0]
    army_set.delete(best_attack[0])
  end

  army_set = Set.new
  immune_army.each do |unit|
    army_set.add(unit.name)
  end

  infection_army.each_with_index do |inf_group, _idx|
    immune_army.each do |imm_group|
      if army_set.include?(imm_group.name)
        damage = inf_group.total_damage(imm_group.weaknesses, imm_group.immunities)
        inf_group.add_target(imm_group.name, damage)
      end
    end
    best_attack = inf_group.get_best_target
    inf_group.pretty_print

    inf_group.final_target = best_attack[0]
    army_set.delete(best_attack[0])
  end

  [immune_army, infection_army]
end

input = 'Inputs/day-24.txt'

immune_army, infection_army = parse_input(input)
# p immune_army.sort_by(&:initiative).reverse
remaining_units = fight(immune_army, infection_army)

puts "remaining_units: #{remaining_units}"
