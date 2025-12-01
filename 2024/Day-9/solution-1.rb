def load_input(input)
    File.read(input).chomp.chars.map(&:to_i)
end


def compress_disk(disk_map)
    
    files_on_disk = convert_disk_map_to_files_on_disk (disk_map)
    compressed_files_on_disk = compress_files(files_on_disk)
    check_sum = calculate_check_sum(compressed_files_on_disk)

    check_sum

end

def calculate_check_sum(compressed_files_on_disk)
    total = 0

    compressed_files_on_disk.each_with_index do |val, idx|
        total += val * idx
    end

    total
end

def convert_disk_map_to_files_on_disk (disk_map)
    file_id = 0
    files_on_disk = []
    disk_map.each_with_index do |val, idx|
        is_file =  idx % 2 == 0 
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
    end
    
    files_on_disk
end

def compress_files(files_on_disk)
    compressed_files_on_disk = []
    r_idx = files_on_disk.size-1

    files_on_disk.each_with_index do |val, idx|
        if r_idx < idx
            break
        end
        if val == "."
            for i in r_idx.downto(idx)
                if files_on_disk[i] != "."
                    compressed_files_on_disk.push(files_on_disk[i])

                    r_idx = i-1
                    break
                end
            end
        else
            compressed_files_on_disk.push(val)
        end
    end
    compressed_files_on_disk
end


input_file = "Inputs/sample.txt"
#input_file = "Inputs/inputs1.txt"

disk_map = load_input(input_file)

check_sum = compress_disk(disk_map)

puts "Check sum: #{check_sum}"