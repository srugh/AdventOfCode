# frozen_string_literal: true

def parse_file(path)
  workflows = {}
  parts = []

  top, bottom = File.read(path).split("\n\n").map { |chunk| chunk.split("\n") }

  top.each do |wf|
    steps = []
    name, rules_str = wf.split('{')
    rules_str = rules_str.delete('}')
    rules_str.split(',').each do |rule_str|
      temp = rule_str.split(':')
      if temp.size == 1
        steps.push([temp[0]])
      elsif temp[0].include?('<')
        eq = temp[0].split('<')
        steps.push([eq[0], '<', eq[1].to_i, temp[1]])
      elsif temp[0].include?('>')
        eq = temp[0].split('>')
        steps.push([eq[0], '>', eq[1].to_i, temp[1]])
      end
    end
    workflows[name] = steps
  end

  bottom.each do |part_str|
    part_str = part_str.delete('{}')
    temp = []
    part_str.split(',').each do |att|
      att_name, val = att.split('=')
      temp.push([att_name, val.to_i])
    end
    parts.push(temp)
  end

  [workflows, parts]
end

def solve_part1(workflows, parts)
  score = 0
  parts.each do |part|
    x = part[0][1]
    m = part[1][1]
    a = part[2][1]
    s = part[3][1]
    accepted = false
    rejected = false
    cur_wf = 'in'
    while accepted == rejected
      rules = workflows[cur_wf]
      rules.each do |rule|
        if rule.size == 1
          rule = rule[0]
          if rule == 'A'
            accepted = true
          elsif rule == 'R'
            rejected = true
          else
            cur_wf = rule
          end
          break
        elsif rule.size == 4
          result = ''
          case rule[0]
          when 'x'
            if rule[1] == '>'
              result = rule[3] if x > rule[2]
            elsif rule[1] == '<'
              result = rule[3] if x < rule[2]
            end
          when 'm'
            if rule[1] == '>'
              result = rule[3] if m > rule[2]
            elsif rule[1] == '<'
              result = rule[3] if m < rule[2]
            end
          when 'a'
            if rule[1] == '>'
              result = rule[3] if a > rule[2]
            elsif rule[1] == '<'
              result = rule[3] if a < rule[2]
            end
          when 's'
            if rule[1] == '>'
              result = rule[3] if s > rule[2]
            elsif rule[1] == '<'
              result = rule[3] if s < rule[2]
            end
          end
          if result == 'A'
            accepted = true
            break
          elsif result == 'R'
            rejected = true
            break
          elsif result != ''
            cur_wf = result
            break
          end
        end
      end
      next unless accepted == true

      puts 'Accepted:'
      p part
      score += x + m + a + s
    end
  end
  p score
end

path = 'Inputs/day-19.txt'
workflows, parts = parse_file(path)
solve_part1(workflows, parts)
