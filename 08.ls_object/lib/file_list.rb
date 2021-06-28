require './lib/file_data'
require 'pathname'

class FileList
  attr_reader :long_format, :file_list

  def initialize(pathname, reverse: false, dot_match: false)
    @pathname = pathname
    @file = @pathname.glob('*').sort
    @reverse = reverse
    @dot_match = dot_match
    @file_list = initialize_files
  end

  def filename
    @file.map(&:basename).map(&:to_s)
  end

  def max_filename_count
    @file.map { |f| File.basename(f).size }.max
  end

  def total_file_blocks
    @file_list.sum(&:file_blocks)
  end

  def initialize_files
    file_paths = collect_file_paths
    file_paths.map { |file_path| FileData.new(file_path)}
  end

  def collect_file_paths
    pattern = @pathname.join('*')
    params = @dot_match ? [pattern, File::FMN_DOTMATCH] : [pattern]
    file_paths = Dir.glob(*params).sort
    @reverse ? file_paths.reverse : file_paths
  end
end
