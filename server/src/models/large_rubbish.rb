class LargeRubbish < Enemy
  def initialize(id, large_rubbish_type_id, max_hp, x, y)
    super(id, max_hp, x, y)
    @large_rubbish_type_id = large_rubbish_type_id
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