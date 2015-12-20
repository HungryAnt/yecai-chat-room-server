# coding: UTF-8
require 'securerandom'

class MonsterService
  MONSTERS = %w(monster_0002 monster_0004)

  def initialize
    autowired(MapService, BroadcastService)
    @mutex = Mutex.new
    @all_areas = @map_service.get_village_areas
    init_monsters
    init_thread
  end

  def get_map_monster_dict
    map_monster_dict = {}
    @mutex.synchronize {
      @all_areas.each do |area|
        if @area_monsters_disc[area.id].size > 0
          map_monster_dict[area.map_id] = true
        end
      end
    }
    map_monster_dict
  end

  def get_monsters_dict(map_id)
    area_ids = @map_service.get_map_area_ids(map_id)
    monsters_dict = {}
    @mutex.synchronize {
      area_ids.each do |area_id|
        if @area_monsters_disc.include? area_id
          monsters_dict[area_id] = @area_monsters_disc[area_id]
        end
      end
    }
    monsters_dict
  end

  private

  def init_monsters
    @area_monsters_disc = {}
    @all_areas.each { |area| @area_monsters_disc[area.id] = [] }
  end

  def init_thread
    Thread.new {
      sleep(1)

      loop {
        begin
          process_monster_generation
          process_monsters
        rescue Exception => e
          LogUtil.error 'monster process raise exception:'
          LogUtil.error e.backtrace.inspect
        end
        sleep(5)
      }
    }
  end

  def process_monster_generation
    @mutex.synchronize {
      # 最多允许同时存在4个怪兽
      return if get_monsters_count >= 4
    }

    area = @all_areas[rand(@all_areas.size)]

    @mutex.synchronize {
      return if has_monsters? area
    }

    if rand(3) == 0
      x, y = random_large_available_position(area)
      monster = generate_random_monster(x, y)
      add_monster area, monster
    end
  end

  def process_monsters

  end

  def get_monsters_count
    @area_monsters_disc.values.inject(0) do |sum, monsters|
      sum + monsters.count
    end
  end

  def has_monsters?(area)
    @area_monsters_disc[area.id].size > 0
  end

  def random_large_available_position(area)
    row, col = area.random_large_available_location
    Area.get_position(row, col)
  end

  def generate_random_monster(x, y)
    id = SecureRandom.uuid
    max_hp = 1500

    monster_type_id = MONSTERS[rand(MONSTERS.size)] # "#{'%04d' % rand(MONSTER_TYPE_COUNT)}"
    Monster.new(id, monster_type_id, max_hp, x, y)
  end

  def add_monster(area, monster)
    @mutex.synchronize {
      monsters = @area_monsters_disc[area.id]
      monsters << monster
    }
    notify_monster_created area, monster
  end

  def notify_monster_created(area, monster)
    map = monster.to_map
    send_notify_msg area, map, MonsterMessage::Action::CREATE
  end

  def send_notify_msg(area, monster_map, action)
    msg = MonsterMessage.new(area.id, monster_map, action)
    @broadcast_service.send area.map_id, msg.to_json
  end
end