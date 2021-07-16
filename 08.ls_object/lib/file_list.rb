# frozen_string_literal: true

require './lib/file_data'
require 'pathname'

class FileList
  attr_reader :long_style, :file_list

  def initialize(path_name, reverse: false, dot_match: false)
    @path_name = path_name
    @file = @path_name.glob('*').sort
    @reverse = reverse
    @dot_match = dot_match
    @file_list = file_data
  end

  def file_names
    @file_list.map(&:file_name)
  end

  def max_filename_count
    @file.map { |f| File.basename(f).size }.max
  end

  def total_file_blocks
    @file_list.sum(&:file_blocks)
  end

  def file_data
    file_paths = collect_file_paths
    file_paths.map { |file_path| FileData.new(file_path) }
  end

  def collect_file_paths
    pattern = @path_name.join('*')
    params = @dot_match ? [pattern, File::FNM_DOTMATCH] : [pattern]
    file_paths = Dir.glob(*params).sort
    @reverse ? file_paths.reverse : file_paths
  end
end
