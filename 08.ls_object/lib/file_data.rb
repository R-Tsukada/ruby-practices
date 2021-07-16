require 'etc'

class FileData
  MODE_TABLE = {
    '0' => '---',
    '1' => '-x-',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(file_path)
    @file_path = file_path
    @file_stat = File::Stat.new(@file_path)
  end

  def file_blocks
    @file_stat.blocks
  end

  def nlink
    @file_stat.nlink.to_s
  end

  def file_owner_name
    Etc.getpwuid(@file_stat.uid).name
  end

  def file_group_name
    Etc.getgrgid(@file_stat.gid).name
  end

  def bytesize
    @file_stat.size.to_s
  end

  def mtime
    @file_stat.mtime.strftime('%_m %e %R')
  end

  def file_name
    File.basename(@file_path)
  end

  def type
    case @file_stat.ftype
    when 'directory'
      'd'
    when 'link'
      'l'
    else
      '-'
    end
  end

  def mode
    digits = @file_stat.mode.to_s(8)[-3..]
    digits.gsub(/./, MODE_TABLE)
  end
end
