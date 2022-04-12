# file containing the file operations
require_relative('constants')
# moduels needed for weather man class
module FileOperations
  include Constants
  def open_file(filename)
    file = File.open(filename, 'r')
    @lines = file.readlines
    file.close
  end

  def get_filenames(filenames, date)
    files = filenames.map do |x|
      x if x.include?(date[0]) && (date.length == 1 ? true : x.downcase.include?(MONTHS[date[1]]))
    end
    files.delete(nil)
    files
  end
end
