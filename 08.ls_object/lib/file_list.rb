class FileList
  def initialize(pathname)
    @pathname = pathname.glob('*').sort
  end

  def filename
    @pathname.map(&:basename).map(&:to_s)
  end

  def max_filename_count
    @pathname.map { |f| File.basename(f).size }.max
  end
end
