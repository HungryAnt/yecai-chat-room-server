# coding: UTF-8
require 'securerandom'

class AreaItemsService
  GRID_WIDTH = 10
  GRID_HEIGHT = 10
  FOOD_TYPE_COUNT = 38
  TIME_OUT = 60 # 60s超时，物品消失

  def initialize
    autowired(MapService, BroadcastService)
    @mutex = Mutex.new
    @all_areas = @map_service.get_all_areas
    init_area_items
    init_item_generate_thread
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

      begin
        process_items_loop
      rescue Exception => e
        puts 'get_messages raise exception:'
        puts e.message
        puts e.backtrace.inspect
      end
    }
  end

  def process_items_loop
    loop {
      @all_areas.each do |area|
        delete_time_out_items(area)
      end

      @all_areas.each do |area|
        if rand(5) == 0  # 1/5概率出现food
          row, col = area.random_available_location
          x, y = get_position(row, col)
          food_type_id = rand(FOOD_TYPE_COUNT)
          id = SecureRandom.uuid
          food = Food.new(id, food_type_id, x, y, 50)
          add_item(area.map_id, area.id, food)
        end
      end

      sleep(5)
    }
  end

  def add_item(map_id, area_id, item)
    items = @areas_items_disc[area_id]
    @mutex.synchronize {
      items << item
    }

    item_map = item.to_map
    area_item_msg = AreaItemMessage.new(area_id, item_map, AreaItemMessage::Action::CREATE)
    @broadcast_service.send map_id, area_item_msg.to_json
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
    deleted_items.each {|item| notify_item_deleted(area, item)}
  end

  def notify_item_deleted(area, item)
    item_map = item.to_id_map
    area_item_msg = AreaItemMessage.new(area.id, item_map, AreaItemMessage::Action::DELETE)
    @broadcast_service.send area.map_id, area_item_msg.to_json
  end

  def get_position(row, col)
    [GRID_WIDTH * col + GRID_WIDTH / 2, GRID_HEIGHT * row + GRID_HEIGHT / 2]
  end
end