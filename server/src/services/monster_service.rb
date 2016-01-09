# coding: UTF-8
require 'securerandom'

class MonsterService
  MAX_MONSTER_COUNT = 10

  MONSTERS = %w(monster_0001 monster_0002 monster_0004 monster_0005 monster_0006
    monster_0007 monster_0008)

  SNOW_MONSTER = 'monster_20000'

  MONSTER_ACTIONS = [:move, :attack, :stand]

  def initialize
    autowired(MapService, BroadcastService)
    @mutex = Mutex.new
    @all_areas = @map_service.get_village_areas
    init_monsters
    init_thread
  end

  def smash(area_id, monster_id)
    damage = 0
    area = @map_service.get_area area_id
    monster = nil
    @mutex.synchronize {
      monsters = @area_monsters_disc[area_id]
      monster = monsters.find {|item| item.id == monster_id}
      return if monster.nil?
      damage = monster.smash
      monsters.delete monster if monster.destroyed?
    }
    if monster.destroyed?
      notify_monster_destroyed area, monster
    else
      notify_monster_updated_hp area, monster
    end
    damage
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
      # 怪物数量控制
      return if get_monsters_count >= MAX_MONSTER_COUNT
    }

    area = @all_areas[rand(@all_areas.size)]

    @mutex.synchronize {
      return if monsters_size(area) >= 1
    }

    if rand(30) == 0
      x, y = random_large_available_position(area)
      monster = generate_random_monster(area, x, y)
      add_monster area, monster
    end
  end

  def process_monsters
    @area_monsters_disc.each_entry do |area_id, monsters|
      area = @map_service.get_area area_id

      monsters.each do |monster|
        monster_action = MONSTER_ACTIONS[rand(MONSTER_ACTIONS.size)]
        case monster_action
          when :move
            x, y = random_large_available_position area
            max_hor = 500 # 单次移动最大横向偏移
            max_ver = 300 # 单次移动最大纵向偏移
            tx = [x, monster.x - max_hor].max
            tx = [tx, monster.x + max_hor].min
            ty = [y, monster.y - max_ver].max
            ty = [ty, monster.y + max_ver].min
            notify_monster_move area, monster, tx, ty
          when :attack
            notify_monster_attack area, monster
          when :stand
            # 不做处理即可
        end
      end
    end
  end

  def get_monsters_count
    @area_monsters_disc.values.inject(0) do |sum, monsters|
      sum + monsters.count
    end
  end

  def monsters_size(area)
    @area_monsters_disc[area.id].size
  end

  def random_large_available_position(area)
    row, col = area.random_large_available_location
    Area.get_position(row, col)
  end

  def generate_random_monster(area, x, y)
    id = SecureRandom.uuid
    max_hp = 1500

    if area.map_id == 'snow_village'
      monster_type_id = SNOW_MONSTER
    else
      monster_type_id = MONSTERS[rand(MONSTERS.size)] # "#{'%04d' % rand(MONSTER_TYPE_COUNT)}"
    end

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

  def notify_monster_updated_hp(area, monster)
    map = monster.to_map
    send_notify_msg area, map, MonsterMessage::Action::UPDATE_HP
  end

  def notify_monster_destroyed(area, monster)
    map = monster.to_id_map
    send_notify_msg area, map, MonsterMessage::Action::DESTROY
  end

  def notify_monster_move(area, monster, x, y)
    map = monster.to_map
    send_notify_msg area, map, MonsterMessage::Action::MOVE, x:x, y:y
    monster.update_location x, y
  end

  def notify_monster_attack(area, monster)
    map = monster.to_map
    send_notify_msg area, map, MonsterMessage::Action::ATTACK
  end

  def send_notify_msg(area, monster_map, action, detail = {})
    msg = MonsterMessage.new(area.id, monster_map, action, detail)
    @broadcast_service.send area.map_id, msg.to_json
  end
end