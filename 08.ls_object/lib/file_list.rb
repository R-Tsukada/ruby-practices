# frozen_string_literal: true

require './lib/file_data'
require 'pathname'

class FileList

  def initialize(path_name, reverse: false, dot_match: false)
    @path_name = path_name
    @file = @path_name.glob('*').sort
    @reverse = reverse
    @dot_match = dot_match
    @file_contents = file_contents
  end

  def file_names
    @file_contents.map(&:file_name)
  end

  def max_filename_count
    @file.map { |f| File.basename(f).size }.max
  end

  def total_file_blocks
    @file_contents.sum(&:file_blocks)
  end

  def file_contents
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
