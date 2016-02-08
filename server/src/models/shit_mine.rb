class ShitMine
  attr_reader  :id, :user_id, :area_id, :x, :y, :time_in_s

  DELAY_BOMB_TIME = 2 # 2ÃëÖÓ±¬Õ¨

  def initialize(id, user_id, area_id, x, y)
    @id, @user_id = id, user_id
    @area_id, @x, @y = area_id, x, y
    @time_in_s = Time.now.to_i
  end

  def bomb?
    Time.now.to_i - @time_in_s > DELAY_BOMB_TIME
  end
end