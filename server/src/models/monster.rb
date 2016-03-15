class Monster < Enemy
  attr_reader :monster_type_id
  attr_accessor :monster_info

  def initialize(id, monster_type_id, max_hp, x, y)
    super(id, max_hp, x, y)
    @monster_type_id = monster_type_id
    @monster_info = nil
  end

  # def get_hp_dec
  #   100
  # end

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