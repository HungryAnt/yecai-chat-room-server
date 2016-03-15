require_relative 'monster_base_service'

class VillageMonsterService < MonsterBaseService
  MAX_MONSTER_COUNT = 10

  MONSTERS = %w(monster_0001 monster_0002 monster_0004 monster_0005 monster_0006
    monster_0007 monster_0008)

  SNOW_MONSTER = 'monster_20000'

  def initialize(map_service)
    init_areas map_service.get_village_areas
  end

  def is_total_count_enough?(total_count)
    total_count >= MAX_MONSTER_COUNT
  end

  def is_area_count_enough?(area, area_monsters_count)
    area_monsters_count >= 1
  end

  def rand_value
    30
  end

  def generate_monster(area, monster_type_ids)
    x, y = area.random_large_available_position
    monster = generate_random_monster(area, x, y)
    monster
  end

  def rand_monster_type_id(area)
    if area.map_id == 'snow_village'
      monster_type_id = SNOW_MONSTER
    else
      monster_type_id = MONSTERS[rand(MONSTERS.size)] # "#{'%04d' % rand(MONSTER_TYPE_COUNT)}"
    end
    monster_type_id
  end

  def random_large_available_position(area, monster)
    area.random_large_available_position
  end

end