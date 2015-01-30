class LinkProvider
  def initialize
    @last_left = 0
    @last_right = 0
  end

  def provide
    @skip = rand(2) == 1
    @reuse = rand(2) == 1

    if (@last_left - @last_right).abs < 10
      @last_right += 100
    end

    if @skip
      @last_left += 1
      @last_right += 1
      return provide
    end

    if @reuse
      reuseleft = rand(2) == 1

      if reuseleft
        return {
          left_type: 'resource',
          left_id: @last_left,
          right_type: 'resource',
          right_id: @last_right += 1,
        }
      else
        return {
          left_type: 'resource',
          left_id: @last_left += 1,
          right_type: 'resource',
          right_id: @last_right,
        }
      end
    end

    return {
      left_type: 'resource',
      left_id: @last_left += 1,
      right_type: 'resource',
      right_id: @last_right += 1,
    }
  end
end
