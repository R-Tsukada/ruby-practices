class FileList
  def initialize(pathname, reverse: false, dot_match: false)
    @pathname = pathname.glob('*').sort
    @reverse = reverse
    @dot_match = dot_match
    @files = initialize_files
  end

  def filename
    @pathname.map(&:basename).map(&:to_s)
  end

  def max_filename_count
    @pathname.map { |f| File.basename(f).size }.max
  end

  def total_file_blocks
    @files.sum(&:file_blocks)
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
