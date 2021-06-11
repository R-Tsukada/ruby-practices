# frozen_string_literal: true

require 'minitest/autorun'
require './lib/run_ls'

class LsCommandTest < Minitest::Test
  TARGET_PATHNAME = Pathname('./test/fixture/fjord-books_app/')

  def test_run_ls_width_80
    expected = <<~TEXT.chomp
      Gemfile                 config                  postcss.config.js
      Gemfile.lock            config.ru               public
      README.md               db                      storage
      Rakefile                lib                     test
      app                     log                     tmp
      babel.config.js         node_modules            vendor
      bin                     package.json            yarn.lock
    TEXT
    run_ls = RunLs.new(TARGET_PATHNAME, width: 80)
    assert_equal expected, run_ls.format_table(TARGET_PATHNAME)#RunLs.new(TARGET_PATHNAME, width: 80)
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
    assert_equal expected, run_ls(TARGET_PATHNAME, width: 80, show_dots: true)
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
    assert_equal expected, run_ls(TARGET_PATHNAME, width: 80, reverse: true)
  end

  def test_run_ls_long_format
    expected = `ls -l #{TARGET_PATHNAME}`.chomp
    assert_equal expected, RunLs.new(TARGET_PATHNAME, long_format: true)
  end
end

