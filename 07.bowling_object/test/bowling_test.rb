# frozen_string_literal: true

require 'minitest/autorun'
require './lib/game'

class BowlingTest < MiniTest::Test
  def test_score1
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 139, game.score
  end

  def test_score2
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X')
    assert_equal 164, game.score
  end

  def test_score3
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,3')
    assert_equal 132, game.score
  end

  def test_score4
    game = Game.new('X,X,X,X,X,X,X,X,X,X,X')
    assert_equal 300, game.score
  end
end
