# frozen_string_literal: true

require './lib/game'

if __FILE__ == $PROGRAM_NAME
  game = Game.new(ARGV[0])
  puts game.score
end
