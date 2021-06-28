require './lib/format/base'
require 'pathname'
require './lib/file_list'
require './lib/file_data'

class LongStyle
  def initialize(file, long_format: false)
    @file = file
    @long_format = long_format
  end

  def run_ls_long_format
    long_format
  end

  def long_format
    total_blocks = @file.total_file_blocks
    body = long_format_body
    "total #{total_blocks}\n#{body}"
  end

  def long_format_body
    @file.file_list.map do |file|
      long_format_row(file, *max_size)
    end.join("\n")
  end

  def long_format_row(file, max_link, max_owner, max_group, max_size)
    [
      "#{file.type}#{file.mode}",
      "  #{file.nlink.rjust(max_link)}",
      " #{file.file_owner_name.rjust(max_owner)}",
      "  #{file.file_group_name.rjust(max_group)}",
      "  #{file.bytesize.rjust(max_size)}",
      " #{file.mtime}",
      " #{file.filename}"
    ].join
  end

  def max_size
    [
      @file.file_list.map { |file| file.nlink.size }.max,
      @file.file_list.map { |file| file.file_owner_name.size }.max,
      @file.file_list.map { |file| file.file_group_name.size }.max,
      @file.file_list.map { |file| file.bytesize.size }.max
    ]
  end
end
