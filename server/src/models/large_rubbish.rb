class LargeRubbish
  def initialize(id, large_rubbish_type_id, max_hp, x, y)
    @id = id
    @large_rubbish_type_id = large_rubbish_type_id
    @max_hp = @hp = max_hp
    @x, @y = x, y
  end

  def smash
    hp_dec = 3
    hp_dec = @hp if hp_dec > @hp
    @hp -= hp_dec
    hp_dec
  end

  def destroyed?
    @hp < 0.00001
  end

  def to_map
    {
        id: @id,
        x: @x,
        y: @y,
        large_rubbish_type_id: @large_rubbish_type_id,
        max_hp: @max_hp,
        hp: @hp
    }
  end
end