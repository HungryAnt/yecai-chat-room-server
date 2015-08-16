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

  private

  def init_area_items
    @areas_items_disc = {}
    @all_areas.each do |area|
      @areas_items_disc[area.id] = []
    end
  end

  def init_item_generate_thread
    Thread.new {
      sleep(3)

      loop {
        @all_areas.each do |area|
          delete_time_out_itmes(area_id)
        end

        @all_areas.each do |area|
          row, col = area.random_available_location
          x, y = get_position(row, col)
          food_type_id = rand(FOOD_TYPE_COUNT)
          id = SecureRandom.uuid
          food = Food.new(id, food_type_id, x, y)
          add_item(area.map_id, area.id, food)
        end

        sleep(5)
      }
    }
  end

  def add_item(map_id, area_id, item)
    items = @areas_items_disc[area_id]
    @mutex.synchronize {
      items << item
    }

    item_map = item.to_map
    area_item_msg = AreaItemMessage.new(area_id, item_map, 'create')
    @broadcast_service.send map_id, area_item_msg.to_json
  end

  def delete_item(area_id)
    items = @areas_items_disc[area_id]
    @mutex.synchronize {
      items.reject! {|item| item.id == area_id}
    }

    area_item_msg = AreaItemMessage.new(area_id, {}, 'delete')
    @broadcast_service.send map_id, area_item_msg.to_json
  end

  def get_map_items(map_id)
    area_ids = @map_service.get_map_area_ids(map_id)
    items = []
    @mutex.synchronize {
      area_ids.each do |area_id|
        items += @areas_items_disc[area_id]
      end
    }
    items
  end

  def delete_time_out_items(area_id)
    current_time_in_s = Time.now.to_i
    deadline_time_in_s = current_time_in_s - TIME_OUT
    @mutex.synchronize {
      items = @areas_items_disc[area_id]
      items.reject! {|item| item.time_in_s <= deadline_time_in_s}
    }
  end

  def get_position(row, col)
    [GRID_WIDTH * col + GRID_WIDTH / 2, GRID_HEIGHT * row + GRID_HEIGHT / 2]
  end
end