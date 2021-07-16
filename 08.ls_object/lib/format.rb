
require 'pathname'
require './lib/file_list'
require './lib/file_data'

class Format
  def initialize(file, long_style: false, short_style: false)
    @file = file
    @long_style = long_style
    @short_style = short_style
  end

  def run_ls
    @long_style ? long_style : short_style
  end

  def long_style
    total_blocks = @file.total_file_blocks
    body = long_style_body
    "total #{total_blocks}\n#{body}"
  end

  def long_style_body
    @file.file_contents.map do |file|
      long_style_row(file, *max_size)
    end.join("\n")
  end

  def long_style_row(file, max_link, max_owner, max_group, max_size)
    [
      "#{file.type}#{file.mode}",
      "  #{file.nlink.rjust(max_link)}",
      " #{file.file_owner_name.rjust(max_owner)}",
      "  #{file.file_group_name.rjust(max_group)}",
      "  #{file.bytesize.rjust(max_size)}",
      " #{file.mtime}",
      " #{file.file_name}"
    ].join
  end

  def max_size
    [
      @file.file_contents.map { |file| file.nlink.size }.max,
      @file.file_contents.map { |file| file.file_owner_name.size }.max,
      @file.file_contents.map { |file| file.file_group_name.size }.max,
      @file.file_contents.map { |file| file.bytesize.size }.max
    ]
  end

  def short_style
    short_style_format_table(transpose_files, @file.max_filename_count)
  end

  def short_style_format_table(transpose_files, max_filename_count)
    transpose_files.map do |f|
      short_style_format_row(f, max_filename_count)
    end.join("\n")
  end

  def short_style_format_row(filenames, max_filename_count)
    filenames.map do |f|
      f ||= ''
      f.ljust(max_filename_count + 7)
    end.join.rstrip
  end

  def row_count
    (@file.file_names.count.to_f / 3).ceil
  end

  def col_count(width, max_filename_count)
    width / (max_filename_count + 1)
  end

  def nested_files
    @file.file_names.each_slice(row_count).to_a
  end

  def transpose_files
    nested_files[0].zip(*nested_files[1..])
  end
end
