# frozen_string_literal: true

require './lib/frame'

# game
class Game
  def initialize(mark)
    @frames = frames(mark.split(',').map { |m| m == 'X' ? 10 : m.to_i })
  end

  def score
    score = 0
    10.times do |n|
      score += @frames[n].score

      if @frames[n].strike?
        score += if n == 9
                   @frames[n].second_mark.score
                 elsif @frames[n + 1].strike? && n != 8
                   @frames[n + 1].score + @frames[n + 2].first_mark.score
                 elsif @frames[n + 1].spare?
                   @frames[n + 1].first_mark.score + @frames[n + 1].second_mark.score
                 else
                   @frames[n + 1].score
                 end
      elsif @frames[n].spare? && n != 9
          score += @frames[n + 1].first_mark.score
      end
    end
    score
  end

  def frames(marks)
    frame_count = 0
    frames = []
    10.times do |n|
      first_mark = marks[frame_count]
      second_mark = marks[frame_count += 1] if first_mark != 10 || n == 9
      third_mark = marks[frame_count += 1] if n == 9
      frames << Frame.new(first_mark, second_mark, third_mark)
      frame_count += 1
    end
    frames
  end
end

