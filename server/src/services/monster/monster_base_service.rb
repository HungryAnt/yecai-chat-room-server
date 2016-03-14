class MonsterBaseService

  attr_reader :areas

  def init_areas(areas)
    @areas = areas
  end

  def get_random_area
    @areas[rand(@areas.size)]
  end

  def generate_random_monster(area, x, y)
    id = SecureRandom.uuid
    max_hp = 1500
    monster_type_id = rand_monster_type_id area
    Monster.new(id, monster_type_id, max_hp, x, y)
  end
end