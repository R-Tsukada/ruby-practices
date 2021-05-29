# frozen_string_literal: true
require 'pathname'
#require './lib/format.rb'

  MODE = {
    '0' => '---',
    '1' => '-x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }

  def run_ls(pathname, width: 80, long_format: false, reverse: false, show_dots: false)
    filenames = pathname.glob('*').sort
    long_format ? ls_long(filenames) : ls_short(filenames, width)
  end

  def format_table(filenames, max_file_count)
    filenames.map do |row_files|
      short_format(row_files, max_file_count)
    end.join("\n")
  end

  def short_format(row_files, max_file_count)
    row_files.map do |file_path|
      basename = file_path ? File.basename(file_path) : ''
      basename.ljust(max_file_count + 1)
    end.join.rstrip
  end

  #lオプションに必要な情報を取得する
  def ls_long(pathnames)
    blocks = 0
    pathnames.map do |pathname|
      stat = pathname.stat
      blocks += stat.blocks
    end

    file = ["total #{blocks}"]
    file += pathnames.map do |filename|
      ls_long_format(filename)
    end
    file.join("\n")
  end

  #lオプションのフォーマットを整える
  def ls_long_format(filename)
    ret = ''
    stat = filename.stat
    ret += filename.directory? ? 'd' : '-'
    mode = sprintf("%o", stat.mode)[-3..-1]
    ret += mode_format(mode)
    ret += " #{stat.nlink.to_s.rjust(4)}"
    ret += " #{Etc.getpwuid(stat.uid).name}"
    ret += "  #{Etc.getgrgid(stat.gid).name}"
    ret += "#{stat.size.to_s.rjust(8)}"
    ret += " #{stat.mtime.strftime("%_m %e %H:%M")}"
    ret += " #{filename.basename}"
  end

  def mode_format(digits)
    digits.each_char.map do |d|
      MODE[d]
    end.join
  end

  def ls_short(filenames, width)
    filepaths = filenames.map { |f| File.basename(f) }
    max_file_count = filenames.map { |f| File.basename(f).size }.max #17
    col_count = width / (max_file_count + 4) #4
    row_count = (filepaths.count.to_f / col_count).ceil
    filepath_array = filepaths.each_slice(row_count).to_a
    filepath_transpose = filepath_array.transpose
    format_table(filepath_transpose, max_file_count)
  end

  def reverse(filenames)
    filepaths = filenames.map { |f| File.basename(f) }.reverse
  end

  def show_dots(pathname)
    filenames = pathname.glob(ARGV[0] || '.').sort
    filepaths = filenames.map { |f| File.basename(f) }
  end
