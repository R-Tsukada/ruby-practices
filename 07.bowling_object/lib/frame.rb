# frozen_string_literal: true

require './lib/shot'

class Frame
  def initialize(first_mark, second_mark, third_mark)
    @first_mark = Shot.new(first_mark)
    @second_mark = Shot.new(second_mark)
    @third_mark = Shot.new(third_mark)
  end

  def score
    @first_mark.score + @second_mark.score + @third_mark.score
  end

  def strike_bonus
    @first_mark.score + @second_mark.score
  end

  def spare_bonus
    @first_mark.score
  end

  def strike?
    @first_mark.score == 10
  end

  def spare?
    !strike? && [@first_mark.score, @second_mark.score].sum == 10
  end
end
