require 'csv'

## Read inputs for Arrays, "Left" and "Right"
def populateReports(input_file, reports)
    File.foreach(input_file) do |line|
        report = []
        values = line.split(/\s+/)
        
        values.each do |value|
            report.push(value.to_i)
        end
        reports.push(report)
    end
end


def calculateTotalSafeReports(reports)
    total_safe = 0

    reports.each do |report|
        levels_ascending = true
        levels_descending = true
        levels_tolerance = true
        total_levels = report.size
        report_num = 0
    
        (report.size-1).times do |i|
            if (levels_ascending == true) && (report[i] > report[i+1])
                levels_ascending = false
            end

            if (levels_descending == true) && (report[i] < report[i+1])
                levels_descending = false
            end

            level_difference = (report[i] - report[i+1]).abs
            if (levels_tolerance == true) && ((level_difference < 1) || (level_difference > 3))
                levels_tolerance = false
            end
        end

        if (levels_ascending == true || levels_descending == true) && levels_tolerance == true
            total_safe += 1
        end
       
    end

    return total_safe
end



## Initalize and run

sample_file = "../Inputs/sample.txt"
real_file = "../Inputs/input.txt"

reports = []

total_safe_reports = 0


# initalize arrays from input file
#populateReports(sample_file, reports)
populateReports(real_file, reports)


# calculate total safe reports
total_safe_reports = calculateTotalSafeReports(reports)

# print total distance
puts total_safe_reports


