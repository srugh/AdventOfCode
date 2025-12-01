require 'csv'


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


def isReportSafe(report)
 
    levels_not_ascending = []
    levels_not_descending = []
    levels_out_of_tolerance = []

    (report.size-1).times do |i|
        
        if report[i] > report[i+1]
           levels_not_ascending.push(i+1)
        end

        if report[i] < report[i+1]
            levels_not_descending.push(i+1)
        end

        level_difference = (report[i] - report[i+1]).abs
        
        if (level_difference < 1) || (level_difference > 3)
            
            levels_out_of_tolerance.push(i+1)
        end
        
    end

    if (levels_not_ascending.empty? || levels_not_descending.empty?) && levels_out_of_tolerance.empty?
        return true
    elsif (levels_not_ascending.size > 1 && levels_not_descending.size > 1) || levels_out_of_tolerance.size > 1
        return false
    end

    return false
end


def calculateTotalSafeReports(reports)
    total_safe = 0
    reportsToRetry = []
    reports.each do |report|
        if isReportSafe(report)
            total_safe += 1
        else
            reportsToRetry.push(report)
        end
    end

    reportsToRetry.each do |report|
        for i in 0..report.size-1   
            next if report[i].nil?
            mini_report = []
            for j in 0..report.size-1
                if i != j
                    mini_report.push(report[j])
                end
            end
            if isReportSafe(mini_report)
                total_safe += 1
                break
            end
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


