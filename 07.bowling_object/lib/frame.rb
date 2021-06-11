# frozen_string_literal: true

require './lib/mark'

class Frame
  attr_reader :first_mark, :second_mark, :third_mark

  def initialize(first_mark, second_mark, third_mark)
    @first_mark = Mark.new(first_mark)
    @second_mark = Mark.new(second_mark)
    @third_mark = Mark.new(third_mark)
  end

  def score
    @first_mark.score + @second_mark.score + @third_mark.score
  end

  def strike?
    @first_mark.score == 10
  end

  def spare?
    !strike? && [@first_mark.score, @second_mark.score].sum == 10
  end
end
