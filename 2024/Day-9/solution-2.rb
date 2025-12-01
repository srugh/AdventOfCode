def load_input(input)
    File.read(input).chomp.chars.map(&:to_i)
end


def compress_disk(disk_map)
    
    files_on_disk, files_hash, total_files = convert_disk_map_to_files_on_disk (disk_map)
    compressed_files_on_disk = compress_files(files_on_disk, files_hash, total_files)
    check_sum = calculate_check_sum(compressed_files_on_disk)

    check_sum

end

def calculate_check_sum(compressed_files_on_disk)
    total = 0

    compressed_files_on_disk.each_with_index do |val, idx|
        if val != "*"
            total += val * idx
        end
    end

    total
end

def convert_disk_map_to_files_on_disk (disk_map)
    files_hash = Hash.new{ |hash, key| hash[key] = [] }

    file_id = 0
    true_idx = 0
    files_on_disk = []
    

    disk_map.each_with_index do |val, idx|
        is_file =  idx % 2 == 0 

        if is_file == true 
            files_hash[file_id] << [true_idx, val]
        else
            files_hash["*"] << [true_idx, val]
        end

        for i in 0..val-1
            if is_file == true
                files_on_disk.push(file_id)


            else
                files_on_disk.push(".")

            end
        end
        if is_file == true
            file_id += 1
        end
        true_idx += val
    end
    
    
    [files_on_disk, files_hash, file_id]
end

def compress_files(files_on_disk, files_hash, total_files)
    compressed_files_on_disk = []
    for i in (total_files-1).downto(0)
        idx, size = files_hash[i][0]


        count = 0
        files_hash["*"].each do |blank_idx, blank_size|
            if size <= blank_size && idx > blank_idx
             
                files_hash[i][0][0] = blank_idx

               
                files_hash["*"][count] = [files_hash["*"][count][0]+size, files_hash["*"][count][1]-size]
                files_hash["*"] << [idx, size]
                
        
                break
     
            end
            count = count+1
        end
        
    end


    files_hash.each do |key, value|
       # if key != "*"
            value.each do |idx, size|
                for i in 0..size-1
                    if size > 0 
                        compressed_files_on_disk[idx+i] = key
                    end
                end         
            end
       # end


    end


    compressed_files_on_disk
end


#input_file = "Inputs/sample.txt"
input_file = "Inputs/inputs1.txt"

disk_map = load_input(input_file)

check_sum = compress_disk(disk_map)

puts "Check sum: #{check_sum}"