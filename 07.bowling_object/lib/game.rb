# frozen_string_literal: true

require './lib/frame'

class Game
  def initialize(mark)
    @frames = frames(mark.split(',').map { |m| m == 'X' ? 10 : m.to_i })
  end

  def score
    score = 0
    10.times do |n|
      score += @frames[n].score

      points = []
      points << (@frames[n + 1]&.first_mark&.score || 0)

      if n <= 9
        if @frames[n - 1]&.strike?
          points << 10
        else
          points << (@frames[n + 1]&.second_mark&.score || 0)
        end
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

