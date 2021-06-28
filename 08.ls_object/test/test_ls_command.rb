require 'minitest/autorun'
require './lib/file_list'
require './lib/format/short_style'
require './lib/format/long_style'
require 'pathname'

class LsCommandTest < Minitest::Test
  TARGET_PATHNAME = Pathname('test/fixture/fjord-books_app')

  def test_run_ls
    expected = <<~TEXT.chomp
      Gemfile                 config                  postcss.config.js
      Gemfile.lock            config.ru               public
      README.md               db                      storage
      Rakefile                lib                     test
      app                     log                     tmp
      babel.config.js         node_modules            yarn.lock
      bin                     package.json
    TEXT
    file_list = FileList.new(TARGET_PATHNAME)
    assert_equal expected, ShortStyle.new(file_list).run_ls_short_style
  end

  def run_ls_show_dots
    expected = <<~TEXT.chomp
      .                       Gemfile.lock            node_modules
      ..                      README.md               package.json
      .browserslistrc         Rakefile                postcss.config.js
      .env                    app                     public
      .env.sample             babel.config.js         storage
      .git                    bin                     test
      .gitignore              config                  tmp
      .idea                   config.ru               vendor
      .rubocop.yml            db                      yarn.lock
      .ruby-version           lib
      Gemfile                 log
    TEXT
    file_list = FileList.new(TARGET_PATHNAME, dot_match: true)
    assert_equal expected, ShortStyle.new(file_list).run_ls_short_style
  end

  def run_ls_reverse
    expected = <<~TEXT.chomp
      yarn.lock               package.json            bin
      vendor                  node_modules            babel.config.js
      tmp                     log                     app
      test                    lib                     Rakefile
      storage                 db                      README.md
      public                  config.ru               Gemfile.lock
      postcss.config.js       config                  Gemfile
    TEXT
    file_list = FileList.new(TARGET_PATHNAME, reverse: true)
    assert_equal expected, ShortStyle.new(file_list).run_ls_short_style
  end

  def test_run_ls_long_format
    expected = `ls -l #{TARGET_PATHNAME}`.chomp
    file_list = FileList.new(TARGET_PATHNAME)
    assert_equal expected, LongStyle.new(file_list, long_format: true).run_ls_long_format
  end
end
