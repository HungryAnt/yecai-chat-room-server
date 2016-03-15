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
    config_monsters
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

  def generate_monster(area, monster_type_ids)
    area_info = get_area_info area
    monster_infos = area_info[:monsters]

    return nil if monster_type_ids.size == monster_infos.size

    surplus_monster_infos = monster_infos.clone
    monster_type_ids.each do |monster_type_id|
      found_monster_info = surplus_monster_infos.find {|mi| mi[:type_id] == monster_type_id}
      surplus_monster_infos.delete found_monster_info unless found_monster_info.nil?
    end

    return nil if surplus_monster_infos.size == 0

    monster_info = surplus_monster_infos[rand surplus_monster_infos.size]
    x, y = Area.get_position *monster_info[:location]
    monster = new_monster monster_info[:type_id], monster_info[:max_hp], x, y
    monster.monster_info = monster_info
    monster
  end

  def rand_monster_type_id(area)
    WILD_MONSTERS[rand(WILD_MONSTERS.size)]
  end

  def random_large_available_position(area, monster)
    row, col = area.random_large_available_location_with_origin *(monster.monster_info[:location])
    Area.get_position row, col
  end

  private
  def config_monsters
    @monster_conf = {
        vegetable_field: {
            monsters: [
                { type_id:'wild_monster_0010', max_hp:1000, location: [42, 40] },
                { type_id:'wild_monster_0009', max_hp:1500, location: [42, 80] },
                { type_id:'wild_monster_0011', max_hp:2000, location: [42, 120] },
            ]
        },
        hunting_0: {
            monsters: [
                { type_id:'wild_monster_0001', max_hp:800, location: [39, 40] },
                { type_id:'wild_monster_0002', max_hp:1600, location: [39, 90] },
                { type_id:'wild_monster_0003', max_hp:1600, location: [39, 140] },
                { type_id:'wild_monster_0004', max_hp:2200, location: [25, 199] },
                { type_id:'wild_monster_0004', max_hp:2200, location: [28, 225] },
            ]
        },
        hunting_1: {
            monsters: [
                { type_id:'wild_monster_0006', max_hp:1800, location: [42, 50] },
                { type_id:'wild_monster_0005', max_hp:2000, location: [45, 120] },
                { type_id:'wild_monster_0007', max_hp:2200, location: [42, 170] },
            ]
        },
        hunting_2: {
            monsters: [
                { type_id:'wild_monster_0008', max_hp:3800, location: [42, 40] },
            ]
        },
        circus_0: {
            monsters: [
                { type_id:'wild_monster_0013', max_hp:1500, location: [42, 50] },
                { type_id:'wild_monster_0014', max_hp:2500, location: [42, 100] },
            ]
        },
        circus_1: {
            monsters: [
                { type_id:'wild_monster_0012', max_hp:2000, location: [42, 40] },
                { type_id:'wild_monster_0015', max_hp:3500, location: [42, 105] },
            ]
        }
    }
  end

  def get_area_info(area)
    area_info = @monster_conf[area.id.to_sym]
    if area_info.nil?
      LogUtil.error "area_info is nil, area_id:#{area.id} see config_monsters"
      raise RuntimeError
    end
    area_info
  end
end