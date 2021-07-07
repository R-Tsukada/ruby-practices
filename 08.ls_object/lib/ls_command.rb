# frozen_string_literal: true

require 'optparse'
require 'pathname'
require './lib/file_list'
require './lib/format'

opt = OptionParser.new
short_format = false, long_style = false, reverse = false, dot_match = false
opt.on('-l') { |v| long_style = v }
opt.on('-r') { |v| reverse = v }
opt.on('-a') { |v| dot_match = v }
opt.parse!(ARGV)
path = ARGV[0] || '.'
pathname = Pathname(path)

ls_file_list = FileList.new(pathname, reverse: reverse, dot_match: dot_match)
puts Format.new(ls_file_list, long_style: long_style, short_style: short_format).run_ls
