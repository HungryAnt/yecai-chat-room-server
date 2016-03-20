class AreaItemController < ControllerBase
  def initialize
    super
    autowired(AreaItemsService, UserRubbishService, UserScoreService,
              UserService, UserNutrientService)
  end

  def query_area_items(msg_map, params)
    area_items_query_msg = AreaItemsQueryMessage.from_map(msg_map)
    map_id = area_items_query_msg.map_id
    area_items_dict = @area_items_service.get_area_items_by_map_id map_id
    if area_items_dict.size > 0
      area_items_msgs = []
      area_items_dict.each_pair do |area_id, items|
        unless items.nil?
          items.each do |item|
            area_items_msgs << AreaItemMessage.new(area_id, item.to_map, AreaItemMessage::Action::CREATE)
          end
        end
      end
      area_items_msgs
    else
      nil
    end
  end

  def try_pickup_item(msg_map, params)
    area_item_msg = TryPickupItemMessage.from_map(msg_map)
    user_id = area_item_msg.user_id
    area_id = area_item_msg.area_id
    item_id = area_item_msg.item_id
    target_item = @area_items_service.try_pickup area_id, item_id
    if target_item.nil?
      nil
    else
      if target_item.instance_of? Rubbish
        @user_rubbish_service.add_rubbish area_item_msg.user_id, target_item.rubbish_type_id
        @user_score_service.inc_rubbish_score user_id
      elsif target_item.instance_of? Nutrient
        @user_nutrient_service.add_nutrient area_item_msg.user_id, target_item.nutrient_type_id
        @user_score_service.inc_nutrient_score user_id
      end
      [AreaItemMessage.new(area_id, target_item.to_map, AreaItemMessage::Action::PICKUP)]
    end
  end

  def discard_item(msg_map, params)
    discard_item_msg = DiscardItemMessage.from_map(msg_map)
    area_id = discard_item_msg.area_id
    item_map = discard_item_msg.item_map

    item = ItemFactory.create_item item_map
    @area_items_service.discard area_id, item
    nil
  end
end