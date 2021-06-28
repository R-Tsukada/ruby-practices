require 'pathname'
require './lib/file_list'

class ShortStyle
  def initialize(file, short_format: false)
    @file = file
    @short_format = short_format
  end

  def run_ls_short_style
    short_format
  end

  def row_count
    (@file.filename.count.to_f / 3).ceil
  end

  def nested_files
    @file.filename.each_slice(row_count).to_a
  end

  def transpose_files
    nested_files[0].zip(*nested_files[1..])
  end

  def short_format
    short_style_format_table(transpose_files, @file.max_filename_count)
  end

  def short_style_format_table(transpose_files, max_filename_count)
    transpose_files.map do |f|
      short_style_format_row(f, max_filename_count)
    end.join("\n")
  end

  def short_style_format_row(filenames, max_file_path_count)
    filenames.map do |f|
      f ||= ''
      f.ljust(max_file_path_count + 7)
    end.join.rstrip
  end
end

