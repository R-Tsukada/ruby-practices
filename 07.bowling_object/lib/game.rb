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

      points = []
      # 9, 10投目がストライクの場合
      points << if n == 8 && @frames[n + 1].strike?
                  [@frames[n + 1].score]
                  #最終フレームがストライクの場合
                elsif n == 9 && @frames[n].strike?
                  [@frames[n].second_mark.score]
                  #最終フレームじゃなく、次もストライクの場合
                elsif n < 9 && @frames[n + 1].strike?
                  [@frames[n + 1].first_mark.score, @frames[n + 2].first_mark.score]
                  # 最終フレーム以外
                elsif n < 9
                  [@frames[n + 1].first_mark.score, @frames[n + 1].second_mark.score]
                  # ストライク以外の最終フレームはbreakする
                else
                  break
                end
      point = points.flatten

      if @frames[n].strike?
        score += point.sum
      elsif @frames[n].spare?
        score += point[0]
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

