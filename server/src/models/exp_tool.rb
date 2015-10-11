class ExpTool
  MAX_LEVEL = 500
  attr_reader :lv, :exp, :max_exp

  def initialize(lv, exp)
    @lv, @exp = lv, exp
    @max_exp = lv_max_exp
  end

  def lv_max_exp
    @lv * 100
  end

  def inc_exp(value)
    exp = @exp + value
    while exp > @max_exp do
      if @lv == MAX_LEVEL
        exp = @max_exp
        break
      end
      exp -= @max_exp
      @lv += 1
      @max_exp = lv_max_exp
    end
    @exp = exp
  end
end