# file containing needed methods for showing the statistics of weather
require_relative('constants')

# module containing the methods that shows the yearly weather stats
module ParseWeatherStats
  include Constants
  def weather_stats_by_year(file)
    open_file(file)
    @lines.delete_at(0)
    max_temp = min_temp = average_humidity = 0
    @lines.each do |line|
      data = line.split(',')
      max_temp += data[MAX_TEMP_IND].to_i
      min_temp += data[MIN_TEMP_IND].to_i
      average_humidity += data[MEAN_HMD_IND].to_i
    end
    show_weather_stats_by_year(max_temp / @lines.length, min_temp / @lines.length, average_humidity / @lines.length)
  end

  def show_weather_stats_by_year(high_avg_temp, low_avg_temp, avg_hmd)
    puts "Highest Average: #{high_avg_temp}C"
    puts "Lowest Average: #{low_avg_temp}C"
    puts "Average Humidity: #{avg_hmd}%"
  end

  def weather_stats_by_month(files)
    max_temp = -273
    min_temp = 10_000
    max_hmd = -1
    max_date = min_date = hmd_date = ''
    files.each do |x|
      open_file(x)
      @lines.delete_at(0)
      @lines.each do |y|
        data = y.split(',')
        max_temp = data[MAX_TEMP_IND].to_i if max_temp <=> nil || max_temp < data[MAX_TEMP_IND].to_i
        min_temp = data[MIN_TEMP_IND].to_i if min_temp <=> nil || min_temp > data[MIN_TEMP_IND].to_i
        max_hmd = data[MAX_HMD_IND].to_i if max_hmd <=> nil || max_hmd < data[MAX_HMD_IND].to_i
        max_date = data[DATE_IND] if max_temp == data[MAX_TEMP_IND].to_i
        min_date = data[DATE_IND] if min_temp == data[MIN_TEMP_IND].to_i
        hmd_date = data[DATE_IND] if max_hmd == data[MAX_HMD_IND].to_i
      end
    end
    show_weather_stats_by_month(max_temp, min_temp, max_hmd, max_date, min_date, hmd_date)
  end

  def show_weather_stats_by_month(*args)
    date = args[3].split('-')
    puts "Highest: #{args[0]}C on #{MONTHS_COMPLETE[date[1]]} #{date[2]}"
    date = args[4].split('-')
    puts "Lowest: #{args[1]}C on #{MONTHS_COMPLETE[date[1]]} #{date[2]}"
    date = args[5].split('-')
    puts "Humid: #{args[2]}% on #{MONTHS_COMPLETE[date[1]]} #{date[2]}"
  end

  def weather_barchart_by_month(file, date)
    open_file(file)
    puts "#{MONTHS_COMPLETE[date[1]]} #{date[0]}"
    @lines.delete_at(0)
    @lines.each do |line|
      data = line.split(',')
      show_single_weather_barchart(data[MAX_TEMP_IND].to_i, data[MIN_TEMP_IND].to_i, data[0].split('-'))
    end
  end

  def show_weather_barchart_by_month(highest_temp, lowest_temp, date)
    output_str = ''
    old_high_temp = highest_temp
    old_low_temp = lowest_temp
    highest_temp = highest_temp.abs
    lowest_temp = lowest_temp.abs
    highest_temp.times { output_str += '+' }
    puts "\e[3m#{format('%02d', date[2] % 31)}\e[0m \e[31m#{output_str}\e[0m \e[3m#{old_high_temp}C\e[23m"
    output_str = ''
    lowest_temp.times { output_str += '+' }
    puts "\e[3m#{format('%02d', date[2] % 31)}\e[0m \e[34m#{output_str}\e[0m \e[3m#{old_low_temp}C\e[23m"
  end

  def show_single_weather_barchart(highest_temp, lowest_temp, date)
    output_str = ''
    old_high_temp = highest_temp
    old_low_temp = lowest_temp
    highest_temp = highest_temp.abs
    lowest_temp = lowest_temp.abs
    output_str += "\e[3m#{format('%02d', date[2] % 31)}\e[0m \e[34m"
    lowest_temp.times { output_str += '+' }
    output_str += "\e[0m\e[31m"
    highest_temp.times { output_str += '+' }
    output_str += "\e[0m \e[3m#{format('%02d', old_low_temp)}C-#{old_high_temp}C\e[23m"
    puts output_str
  end
end
