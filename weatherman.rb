# class for the project/assignment weatherman
class Weatherman
  MONTHS = { '1' => 'jan', '2' => 'feb', '3' => 'mar', '4' => 'apr', '5' => 'may', '6' => 'jun',
             '7' => 'jul', '8' => 'aug', '9' => 'sep', '10' => 'oct', '11' => 'nov', '12' => 'dec' }.freeze
  MONTHS_COMPLETE = { '1' => 'JANUARY', '2' => 'FEBRUARY', '3' => 'MARCH', '4' => 'APRIL', '5' => 'MAY', '6' => 'JUNE',
                      '7' => 'JULY', '8' => 'AUGUST', '9' => 'SEPTEMBER', '10' => 'OCTOBER', '11' => 'NOVEMBER',
                      '12' => 'DECEMBER' }.freeze
  MAX_TEMP_IND = 1
  MIN_TEMP_IND = 3
  MEAN_HMD_IND = 8
  DATE_IND = 0
  MAX_HMD_IND = 7

  def initialize
    @lines = nil
  end

  def option_a(file)
    open_file(file)
    @lines.delete_at(0)
    max_temperature = 0
    min_temperature = 0
    average_humidity = 0
    @lines.each do |line|
      data = line.split(',')
      max_temperature += data[MAX_TEMP_IND].to_i
      min_temperature += data[MIN_TEMP_IND].to_i
      average_humidity += data[MEAN_HMD_IND].to_i
    end
    output_a(max_temperature/@lines.length, min_temperature/@lines.length, average_humidity/@lines.length)
  end

  def output_a(high_avg_temp, low_avg_temp, avg_hmd)
    puts "Highest Average: #{high_avg_temp}C"
    puts "Lowest Average: #{low_avg_temp}C"
    puts "Average Humidity: #{avg_hmd}%"
  end

  def option_e(files)
    max_temp = -273
    min_temp = 10_000
    max_hmd = -1
    max_date = ''
    min_date = ''
    hmd_date = ''
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
    output_e(max_temp, min_temp, max_hmd, max_date, min_date, hmd_date)
  end

  def output_e(max_temp, min_temp, max_hmd, max_date, min_date, hmd_date)
    date = max_date.split('-')
    puts "Highest: #{max_temp}C on #{MONTHS_COMPLETE[date[1]]} #{date[2]}"
    date = min_date.split('-')
    puts "Lowest: #{min_temp}C on #{MONTHS_COMPLETE[date[1]]} #{date[2]}"
    date = hmd_date.split('-')
    puts "Humid: #{max_hmd}% on #{MONTHS_COMPLETE[date[1]]} #{date[2]}"
  end

  def option_c(file, date)
    open_file(file)
    puts "#{MONTHS_COMPLETE[date[1]]} #{date[0]}"
    @lines.delete_at(0)
    @lines.each do |line|
      data=line.split(',')
      bonus_output_c(data[MAX_TEMP_IND].to_i, data[MIN_TEMP_IND].to_i, data[0].split('-'))
    end
  end

  def output_c(highest_temp, lowest_temp, date)
    output_str = ''
    old_high_temp = highest_temp
    old_low_temp = lowest_temp
    highest_temp.abs
    lowest_temp.abs
    highest_temp.times { output_str += '+'}
    puts "\e[3m#{format('%02d', date[2] % 31)}\e[0m \e[31m#{output_str}\e[0m \e[3m#{old_high_temp}C\e[23m"
    output_str = ''
    lowest_temp.times { output_str += '+'}
    puts "\e[3m#{format('%02d', date[2] % 31)}\e[0m \e[34m#{output_str}\e[0m \e[3m#{old_low_temp}C\e[23m"
  end

  def bonus_output_c(highest_temp, lowest_temp, date)
    output_str = ''
    old_high_temp = highest_temp
    old_low_temp = lowest_temp
    highest_temp.abs
    lowest_temp.abs
    output_str += "\e[3m#{format('%02d', date[2] % 31)}\e[0m \e[34m"
    lowest_temp.times { output_str += '+' }
    output_str += "\e[0m\e[31m"
    highest_temp.times { output_str += '+' }
    output_str += "\e[0m \e[3m#{format('%02d', old_low_temp)}C-#{old_high_temp}C\e[23m"
    puts output_str
  end

  def app_start
    info = ARGV.each { |x| x }
    if info[0] != '-a' && info[0] != '-e' && info[0] != '-c'
      puts 'invalid option'
      return
    end
    date = info[1].split('/')
    path = info[2]
    files = get_filenames(Dir["#{path}*"], date)
    option_a(files[0]) if info[0] == '-a' && files.length == 1
    option_c(files[0], date) if info[0] == '-c' && files.length == 1
    option_e(files) if info[0] == '-e'
    puts 'Invalid date with option' if (info[0] == '-a' || info[0] == '-c') && date[1].nil?
  end

  def open_file(filename)
    file = File.open(filename, 'r')
    @lines = file.readlines
    file.close
  end

  def get_filenames(filenames, date)
    files = filenames.map { |x| x if x.include?(date[0]) && (date.length == 1 ? true : x.downcase.include?(MONTHS[date[1]]))}
    files.delete(nil)
    files
  end
end

begin
  w = Weatherman.new
  w.app_start
rescue StandardError => e
  puts "error: #{e}"
end
