class Monster < Enemy
  def initialize(id, monster_type_id, max_hp, x, y)
    super(id, max_hp, x, y)
    @monster_type_id = monster_type_id
  end

  def to_map
    {
        id: @id,
        x: @x,
        y: @y,
        monster_type_id: @monster_type_id,
        max_hp: @max_hp,
        hp: @hp
    }
  end
end