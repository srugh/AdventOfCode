
def parse_input(input_file)
    secrets = []
    File.readlines(input_file). each do |line|
        secrets.push(line.chomp.to_i)
    end
    secrets
end

def calc_secrets_total(secrets)
    tot_array = Array.new(secrets.size, 0)
    secrets.each_with_index do |secret, idx|
        1..2000.times do
            secret = step_1(secret)
            secret = step_2(secret)
            secret = step_3(secret)

            #puts secret
            tot_array[idx] = secret
        end
        
    end
    p tot_array
    tot_array.sum
end

#Calculate the result of multiplying the secret number by 64. Then, mix this result into the secret number. Finally, prune the secret number.
def step_1(secret)
    secret = mix(secret, secret*64)   
    prune(secret)
end
  

#Calculate the result of dividing the secret number by 32. Round the result down to the nearest integer. Then, mix this result into the secret number. Finally, prune the secret number.
def step_2(secret)
    secret = mix(secret, secret/32)
    prune(secret)
end

#Calculate the result of multiplying the secret number by 2048. Then, mix this result into the secret number. Finally, prune the secret number.
def step_3(secret)
    secret = mix(secret, secret*2048)
    prune(secret)
end

def mix(secret, operand)
    secret ^ operand
end

def prune(secret)
    secret % 16777216
end

input_file = "Inputs/sample.txt"
input_file = "Inputs/input.txt"

secrets = []

secrets = parse_input(input_file)
secrets_total = calc_secrets_total(secrets)

puts "Secrets total after 2,000: #{secrets_total}"

