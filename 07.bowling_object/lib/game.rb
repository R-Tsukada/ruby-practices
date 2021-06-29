# frozen_string_literal: true

require './lib/frame'

class Game
  def initialize(mark)
    @frames = frames(mark.split(',').map { |m| m == 'X' ? 10 : m.to_i })
  end

  def score
    score = 0
    @frames.each_with_index do |frame, n|
      score += frame.score

      next unless next_frame(n)

      if frame.strike? && next_frame(n)
        score += next_frame(n).strike_bonus
        score += 10 if @frames[n - 1].strike?
      elsif frame.spare? && next_frame(n)
        score += next_frame(n).spare_bonus
      end
    end
    score
  end
end

def next_frame(current_number)
  @frames.fetch(current_number + 1, nil)
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

