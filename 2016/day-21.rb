
def parse_input(path)
  steps = []
  File.readlines(path, chomp: true).each do |line|
    temp = line.split

    if temp[0] == "swap"
      if temp[1] == "position"
        steps.push([temp[0], temp[1], temp[2].to_i, temp[5].to_i])
      elsif temp[1] == "letter"
        steps.push([temp[0], temp[1], temp[2], temp[5]])
      end
    elsif temp[0] == "rotate"
      if temp[1] == "based"
        steps.push([temp[0], temp[1], temp[6]])
      else
        steps.push([temp[0], temp[1], temp[2].to_i])
      end
    elsif temp[0] == "reverse"
      steps.push([temp[0], temp[2].to_i, temp[4].to_i])
    elsif temp[0] == "move"
      steps.push([temp[0], temp[2].to_i,temp[5].to_i])
    end
  end
  steps
end

def solve_part_1(steps, p_text)
  action, sub_action, arg_1, arg_2 = "", "", "", ""
  puts steps.size
  steps.each_with_index do |step, count|
    case step[0]
    when "swap"
      action, sub_action, arg_1, arg_2 = step
    when "rotate"
      action, sub_action, arg_1, arg_2 = step
    when "reverse" 
      action, arg_1, arg_2 = step
    when "move" 
      action, arg_1, arg_2 = step
    end
    #puts "step #{count}"
    if action == "swap" && sub_action == "position"
      temp = p_text[arg_1]
      p_text[arg_1] = p_text[arg_2]
      p_text[arg_2] = temp
    
    elsif action == "swap" && sub_action == "letter"
      idx_1, idx_2 = "", ""
      p_text.scan(/#{arg_1}/) do |match|
        idx_1 = Regexp.last_match.begin(0)
      end
      p_text.scan(/#{arg_2}/) do |match|
        idx_2 = Regexp.last_match.begin(0)
      end
      temp = arg_1
      p_text[idx_1] = arg_2
      p_text[idx_2] = temp
  
    elsif action == "rotate" && sub_action == "based"
      idx_1 = ""
      p_text.scan(/#{arg_1}/) do |match|
        idx_1 = Regexp.last_match.begin(0)
      end
 
      idx_1 += 1 if idx_1 >= 4
      idx_1 += 1

      chars = p_text.chars
      rotated_chars = chars.rotate(-idx_1)
      p_text = rotated_chars.join

    elsif action == "rotate" && sub_action == "right"
      chars = p_text.chars
      rotated_chars = chars.rotate(-arg_1)
      p_text = rotated_chars.join
     
    elsif action == "rotate" && sub_action == "left"
        chars = p_text.chars
        rotated_chars = chars.rotate(arg_1)
        p_text = rotated_chars.join

    elsif action == "reverse" 
      str = p_text[arg_1..arg_2].reverse
      p_text[arg_1..arg_2] = str
      
    elsif action == "move"
      chars = p_text.chars
      char_to_move = chars.slice!(arg_1) 
      chars.insert(arg_2, char_to_move)
      p_text = chars.join
    end
    puts p_text
    puts
  end
  p_text
end

def solve_part_2(steps, p_text)
  action, sub_action, arg_1, arg_2 = "", "", "", ""
  steps.each_with_index do |step, count|
    case step[0]
    when "swap"
      action, sub_action, arg_1, arg_2 = step
    when "rotate"
      action, sub_action, arg_1, arg_2 = step
    when "reverse" 
      action, arg_1, arg_2 = step
    when "move" 
      action, arg_1, arg_2 = step
    end

    #rputs "step #{count}"
    #p step
    if action == "swap" && sub_action == "position"
      temp = p_text[arg_1]
      p_text[arg_1] = p_text[arg_2]
      p_text[arg_2] = temp
    
    elsif action == "swap" && sub_action == "letter"
      idx_1, idx_2 = "", ""
      p_text.scan(/#{arg_1}/) do |match|
        idx_1 = Regexp.last_match.begin(0)
      end
      p_text.scan(/#{arg_2}/) do |match|
        idx_2 = Regexp.last_match.begin(0)
      end
      temp = arg_1
      p_text[idx_1] = arg_2
      p_text[idx_2] = temp
  
    elsif action == "rotate" && sub_action == "based"
      chars = p_text.chars
      len   = chars.length

      (0...len).each do |rot|
        candidate = chars.rotate(rot).join  # guess previous state (rot left)
        idx       = candidate.index(arg_1)

        # forward rule: rotate right by 1 + idx + (1 if idx >= 4)
        steps_fwd = 1 + idx
        steps_fwd += 1 if idx >= 4
        steps_fwd %= len

        forward = candidate.chars.rotate(-steps_fwd).join
        if forward == p_text
          p_text = candidate
          break
        end
      end

    elsif action == "rotate" && sub_action == "right"
      chars = p_text.chars
      rotated_chars = chars.rotate(arg_1)
      p_text = rotated_chars.join
     
    elsif action == "rotate" && sub_action == "left"
        chars = p_text.chars
        rotated_chars = chars.rotate(-arg_1)
        p_text = rotated_chars.join

    elsif action == "reverse" 
      str = p_text[arg_1..arg_2].reverse
      p_text[arg_1..arg_2] = str
      
    elsif action == "move"
      chars = p_text.chars
      char_to_move = chars.slice!(arg_2) 
      chars.insert(arg_1, char_to_move)
      p_text = chars.join
    end
    puts "#{p_text}"
    puts
  end
  puts "final: #{p_text}"
end


p_text = "abcdefgh"
unscramble = "fbgdceah"
#unscramble = "gfdhebac"
#unscramble = "decab"

p_text = "abcde"
path = "Inputs/day-21.txt"
#path = "Inputs/day-21-sample.txt"
input = parse_input(path)
#solve_part_1(input, p_text)
solve_part_2(input.reverse, unscramble)