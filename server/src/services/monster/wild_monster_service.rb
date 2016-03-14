require_relative 'monster_base_service'

class WildMonsterService < MonsterBaseService
  WILD_MONSTERS = lambda {
    monsters = []
    1.upto(15) do |num|
      monsters << "wild_monster_#{'%04d' % num}"
    end
    monsters
  }.call

  def initialize(map_service)
    init_areas map_service.get_hunting_areas
  end

  def is_total_count_enough?(total_count)
    false
  end

  def is_area_count_enough?(area, area_monsters_count)
    area_monsters_count >= 5
  end

  def rand_value
    1
  end

  def generate_monster(area)
    x, y = area.random_large_available_position
    monster = generate_random_monster(area, x, y)
    monster
  end

  def rand_monster_type_id(area)
    WILD_MONSTERS[rand(WILD_MONSTERS.size)]
  end

  def random_large_available_position(area, monster)
    area.random_large_available_position
  end
end