require_relative 'shot'

class Bonus
  def initialize(first_mark, second_mark)
    @first_mark = Shot.new(first_mark)
    @second_mark = Shot.new(second_mark)
  end

  def strike
    @first_mark.score + @second_mark.score
  end

  def spare
    @first_mark.score
  end
end
