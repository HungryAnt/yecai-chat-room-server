class Enemy
  attr_reader :id

  def initialize(id, max_hp, x, y)
    @id = id
    @max_hp = @hp = max_hp
    @x, @y = x, y
  end

  def smash
    hp_dec = 5
    hp_dec = @hp if hp_dec > @hp
    @hp -= hp_dec
    hp_dec
  end

  def destroyed?
    @hp < 0.00001
  end

  def to_id_map
    {
        id: @id
    }
  end
end