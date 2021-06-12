#!/usr/bin/env ruby
# frozen_string_literal: true

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if mark == 'X'

    @mark == 'X' ? 10 : @mark.to_i
  end
end

