# coding: UTF-8
require 'securerandom'

class AreaItemsService
  RUBBISH_TYPE_COUNT = 12
  NUTRIENT_TYPE_COUNT = 3
  TIME_OUT = 60 # 60s超时，物品消失

  def initialize
    autowired(MapService, BroadcastService)
    @mutex = Mutex.new
    @all_areas = @map_service.get_all_areas
    init_area_items
    init_item_generate_thread

    @food_energy_cache = {}
    @food_energy_cache_mutex = Mutex.new
  end

  def get_area_items_by_map_id(map_id)
    area_ids = @map_service.get_map_area_ids(map_id)
    area_items = {}
    @mutex.synchronize {
      area_ids.each do |area_id|
        area_items[area_id] = @areas_items_disc[area_id]
      end
    }
    area_items
  end

  def try_pickup(area_id, item_id)
    target_item = nil
    @mutex.synchronize {
      items = @areas_items_disc[area_id]
      target_item = items.find {|item| item.id == item_id}
      items.delete target_item unless target_item.nil?
    }
    unless target_item.nil?
      area = @map_service.get_area(area_id)
      notify_item_deleted(area, target_item)
    end
    target_item
  end

  def discard(area_id, item)
    return unless item.instance_of? Food
    @mutex.synchronize {
      items = @areas_items_disc[area_id]
      items << item
    }
    area = @map_service.get_area(area_id)
    notify_item_created area, item
  end

  def cmd_rand_food(area_id, x, y)
    area = @map_service.get_area(area_id)
    food = generate_random_food(x, y)
    add_food(area, food)
  end

  def cmd_rand_many_food(area_id, count)
    area = @map_service.get_area(area_id)
    0.upto(count - 1) do
      row, col = area.random_available_location
      x, y = get_position(row, col)
      food = generate_random_food(x, y)
      add_food(area, food)
    end
  end

  def cmd_rand_rubbish(area_id, x, y)
    area = @map_service.get_area(area_id)
    rubbish = generate_random_rubbish(x, y)
    add_item(area, rubbish)
  end

  def cmd_rand_many_rubbish(area_id, count)
    area = @map_service.get_area(area_id)
    0.upto(count - 1) do
      row, col = area.random_available_location
      x, y = get_position(row, col)
      food = generate_random_rubbish(x, y)
      add_item(area, food)
    end
  end

  def dec_food_energy(food_id, dec_energy)
    @food_energy_cache_mutex.synchronize {
      current_energy = @food_energy_cache[food_id]
      LogUtil.info "dec_food_energy food_id:#{food_id} current_energy:#{current_energy} dec_energy:#{dec_energy}"
      return false if current_energy.nil? || current_energy < dec_energy
      @food_energy_cache[food_id] = current_energy - dec_energy
      return true
    }
  end

  private

  def init_area_items
    @areas_items_disc = {}
    @all_areas.each do |area|
      @areas_items_disc[area.id] = []
    end
  end

  def init_item_generate_thread
    Thread.new {
      sleep(1)

      loop {
        begin
          process_items_generation
        rescue Exception => e
          LogUtil.error 'process_items_generation raise exception:'
          LogUtil.error e.backtrace.inspect
        end
        sleep(5)
      }
    }
  end

  def process_items_generation
    @all_areas.each do |area|
      delete_time_out_items(area)
    end

    @all_areas.each do |area|
      if rand(4) == 0  # 1/4概率出现food
        x, y = get_random_position(area)
        food = generate_random_food(x, y)
        add_food(area, food)
      end
      if rand(13) == 0
        x, y = get_random_position(area)
        rubbish = generate_random_rubbish(x, y)
        add_item(area, rubbish)
      end
      if rand(40) == 0
        x, y = get_random_position(area)
        nutrient = generate_random_nutrient(x, y)
        add_item(area, nutrient)
      end
    end
  end

  def generate_random_food(x, y)
    food_type_id = rand(FoodConfig::FOOD_TYPE_COUNT)
    id = SecureRandom.uuid
    energy = FoodConfig::food_energy food_type_id
    Food.new(id, food_type_id, x, y, energy, energy)
  end

  def generate_random_rubbish(x, y)
    rubbish_type_id = rand(RUBBISH_TYPE_COUNT)
    id = SecureRandom.uuid
    Rubbish.new(id, rubbish_type_id, x, y)
  end

  def generate_random_nutrient(x, y)
    nutrient_type_id = rand(NUTRIENT_TYPE_COUNT)
    id = SecureRandom.uuid
    Nutrient.new(id, nutrient_type_id, x, y)
  end

  def add_food(area, food)
    store_food_energy food.id, food.max_energy
    add_item area, food
  end

  def add_item(area, item)
    @mutex.synchronize {
      items = @areas_items_disc[area.id]
      items << item
    }

    notify_item_created area, item
  end

  def notify_item_created(area, item)
    item_map = item.to_map
    area_item_msg = AreaItemMessage.new(area.id, item_map, AreaItemMessage::Action::CREATE)
    @broadcast_service.send area.map_id, area_item_msg.to_json
  end

  # def delete_item(area_id)
  #   items = @areas_items_disc[area_id]
  #   @mutex.synchronize {
  #     items.reject! {|item| item.id == area_id}
  #   }
  # end

  def delete_time_out_items(area)
    current_time_in_s = Time.now.to_i
    deadline_time_in_s = current_time_in_s - TIME_OUT
    deleted_items = []
    @mutex.synchronize {
      items = @areas_items_disc[area.id]
      items.reject! do |item|
        if item.time_in_s <= deadline_time_in_s
          deleted_items << item
          true
        else
          false
        end
      end
    }
    deleted_items.each do |item|
      delete_food_energy item.id if item.is_a? Food
      notify_item_deleted(area, item)
    end
  end

  def notify_item_deleted(area, item)
    item_map = item.to_id_map
    area_item_msg = AreaItemMessage.new(area.id, item_map, AreaItemMessage::Action::DELETE)
    @broadcast_service.send area.map_id, area_item_msg.to_json
  end

  def get_random_position(area)
    row, col = area.random_available_location
    get_position(row, col)
  end

  def get_position(row, col)
    Area.get_position row, col
  end

  def store_food_energy(food_id, max_energy)
    @food_energy_cache_mutex.synchronize {
      @food_energy_cache[food_id] = max_energy
    }
  end

  def delete_food_energy(food_id)
    @food_energy_cache_mutex.synchronize {
      @food_energy_cache.delete food_id
    }
  end
end