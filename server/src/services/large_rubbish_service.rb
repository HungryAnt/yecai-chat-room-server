# coding: UTF-8
require 'securerandom'

class LargeRubbishService
  LARGE_RUBBISH_TYPE_COUNT = 10

  def initialize
    autowired(MapService, BroadcastService)
    @mutex = Mutex.new
    @all_areas = @map_service.get_village_areas
    init_large_rubbishes
    init_generation_thread
  end

  def init_large_rubbishes
    @area_large_rubbishes_disc = {}
    @all_areas.each do |area|
      @area_large_rubbishes_disc[area.id] = []
    end
  end

  def init_generation_thread
    Thread.new {
      sleep(1)

      loop {
        begin
          process_generation
        rescue Exception => e
          LogUtil.error 'process_generation raise exception:'
          LogUtil.error e.backtrace.inspect
        end
        sleep(5)
      }
    }
  end

  def process_generation
    @mutex.synchronize {
      # 最多允许同时存在4个大型垃圾
      return if large_rubbishes_count >= 4
    }

    area = @all_areas[rand(@all_areas.size)]

    @mutex.synchronize {
      return if has_large_rubbish? area
    }

    if rand(30) == 0
      x, y = random_large_available_position(area)
      large_rubbish = generate_random_large_rubbish(x, y)
      add_large_rubbish area, large_rubbish
    end
  end

  def add_large_rubbish(area, large_rubbish)
    @mutex.synchronize {
      rubbishes = @area_large_rubbishes_disc[area.id]
      rubbishes << large_rubbish
    }
    notify_large_rubbish_created area, large_rubbish
  end

  def smash(area_id, large_rubbish_id)
    damage = 0
    area = @map_service.get_area area_id
    large_rubbish = nil
    @mutex.synchronize {
      large_rubbishes = @area_large_rubbishes_disc[area_id]
      large_rubbish = large_rubbishes.find {|item| item.id == large_rubbish_id}
      return if large_rubbish.nil?
      damage = large_rubbish.smash
      large_rubbishes.delete large_rubbish if large_rubbish.destroyed?
    }
    if large_rubbish.destroyed?
      notify_large_rubbish_destroyed area, large_rubbish
    else
      notify_large_rubbish_updated area, large_rubbish
    end
    damage
  end

  def get_large_rubbishes_dict(map_id)
    area_ids = @map_service.get_map_area_ids(map_id)
    large_rubbishes_dict = {}
    @mutex.synchronize {
      area_ids.each do |area_id|
        if @area_large_rubbishes_disc.include? area_id
          large_rubbishes_dict[area_id] = @area_large_rubbishes_disc[area_id]
        end
      end
    }
    large_rubbishes_dict
  end

  def get_map_large_rubbish_dict
    map_large_rubbish_dict = {}
    @mutex.synchronize {
      @all_areas.each do |area|
        if @area_large_rubbishes_disc[area.id].size > 0
          map_large_rubbish_dict[area.map_id] = true
        end
      end
    }
    map_large_rubbish_dict
  end

  private

  def has_large_rubbish?(area)
    @area_large_rubbishes_disc[area.id].size > 0
  end

  def large_rubbishes_count
    @area_large_rubbishes_disc.values.inject(0) do |sum, rubbishes|
      sum + rubbishes.count
    end
  end

  def random_large_available_position(area)
    row, col = area.random_large_available_location
    Area.get_position(row, col)
  end

  def generate_random_large_rubbish(x, y)
    id = SecureRandom.uuid
    max_hp = 1000
    large_rubbish_type_id = rand(LARGE_RUBBISH_TYPE_COUNT)
    LargeRubbish.new(id, large_rubbish_type_id, max_hp, x, y)
  end

  def notify_large_rubbish_created(area, large_rubbish)
    map = large_rubbish.to_map
    send_notify_msg area, map, LargeRubbishMessage::Action::CREATE
  end

  def notify_large_rubbish_updated(area, large_rubbish)
    map = large_rubbish.to_map
    send_notify_msg area, map, LargeRubbishMessage::Action::UPDATE
  end

  def notify_large_rubbish_destroyed(area, large_rubbish)
    map = large_rubbish.to_id_map
    send_notify_msg area, map, LargeRubbishMessage::Action::DESTROY
  end

  def send_notify_msg(area, large_rubbish_map, action)
    msg = LargeRubbishMessage.new(area.id, large_rubbish_map, action)
    @broadcast_service.send area.map_id, msg.to_json
  end
end