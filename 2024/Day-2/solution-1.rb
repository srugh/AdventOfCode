# frozen_string_literal: true

require 'csv'

## Read inputs for Arrays, "Left" and "Right"
def populateReports(input_file, reports)
  File.foreach(input_file) do |line|
    values = line.split(/\s+/)

    report = values.map(&:to_i)
    reports.push(report)
  end
end

def calculateTotalSafeReports(reports)
  total_safe = 0

  reports.each do |report|
    levels_ascending = true
    levels_descending = true
    levels_tolerance = true
    report.size

    (report.size - 1).times do |i|
      levels_ascending = false if (levels_ascending == true) && (report[i] > report[i + 1])

      levels_descending = false if (levels_descending == true) && (report[i] < report[i + 1])

      level_difference = (report[i] - report[i + 1]).abs
      levels_tolerance = false if (levels_tolerance == true) && ((level_difference < 1) || (level_difference > 3))
    end

    total_safe += 1 if (levels_ascending == true || levels_descending == true) && levels_tolerance == true
  end

  total_safe
end

## Initalize and run
real_file = '../Inputs/input.txt'

reports = []

# initalize arrays from input file
# populateReports(sample_file, reports)
populateReports(real_file, reports)

# calculate total safe reports
total_safe_reports = calculateTotalSafeReports(reports)

# print total distance
puts total_safe_reports
