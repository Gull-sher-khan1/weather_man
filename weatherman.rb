# file containing the weather_man class
require_relative('parse_weather_stats')
require_relative('constants')
require_relative('file_operations')
# class for the project/assignment weatherman
class Weatherman
  include FileOperations
  include ParseWeatherStats
  include Constants
  def initialize
    @lines = nil
  end

  def app_start
    return unless is_valid_input?

    info = ARGV
    date = info[1].split('/')
    path = info[2]
    files = get_filenames(Dir["#{path}*"], date)
    select_case(files, info, date)
  end

  def select_case(files, info, date)
    case info[0]
    when '-a'
      weather_stats_by_year(files[0])
    when '-c'
      weather_barchart_by_month(files[0], date)
    else
      weather_stats_by_month(files)
    end
  end

  def is_valid_input?
    info = ARGV
    if  info.length != 3 || (info[0] != '-a' && info[0] != '-e' && info[0] != '-c') || (
        info[0] == '-e' && info[1].split('/').count != 1) || ((info[0] == '-a' || info[0] == '-c') &&
        info[1].split('/').count != 2)
      puts 'incorrect input!'
      return false
    end
    true
  end
end

begin
  w = Weatherman.new
  w.app_start
rescue StandardError => e
  puts "error: #{e}"
  puts e.backtrace
end
