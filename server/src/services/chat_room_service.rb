# coding: UTF-8

require 'thread'
require_relative 'broadcast_service'
require_relative 'user_service'

class ChatRoomService
  attr_reader :text_messages

  def initialize
    autowired(UserService, BroadcastService, MessageHandlerService,
              AreaItemsService, MapUserCountService,
              UserDataDao, CommandService, UserVehicleDao,
              UserRubbishService, UserNutrientService,
              LargeRubbishService, UserExpService,
              UserScoreService, ChatMessageService)
    @text_messages = []
    @mutex = Mutex.new
    @version_offset = 0
    init_message_handler
  end

  def init_message_handler
    register('command_message') do |msg_map, params|
      cmd_msg = CommandMessage.from_map(msg_map)
      @command_service.process cmd_msg
      nil
    end

    register('init_sync_user_message') do |msg_map, params|
      init_sync_user_msg = InitSyncUserMessage.from_map(msg_map)
      user_id = init_sync_user_msg.user_id
      user_name = init_sync_user_msg.user_name
      @user_data_dao.sync_user user_id, user_name
      lv, exp = @user_data_dao.get_user_lv user_id
      vehicles = @user_vehicle_dao.get_vehicles user_id
      rubbishes = @user_rubbish_service.get_rubbishes user_id
      nutrients = @user_nutrient_service.get_nutrients user_id
      res_sync_user_msg = ResSyncUserMessage.new(user_id, lv, exp, vehicles, rubbishes, nutrients)
      [res_sync_user_msg]
    end

    # register('update_lv_message') do |msg_map, params|
    #   update_lv_msg = UpdateLvMessage.from_map msg_map
    #   user_id, lv, exp = update_lv_msg.user_id, update_lv_msg.lv, update_lv_msg.exp
    #   current_lv, current_exp = @user_data_dao.get_user_lv(user_id)
    #   if lv >= 1 && lv <= 200 && exp >= 0 && lv >= current_lv && lv - current_lv < 3
    #     LogUtil.info "update_user_lv #{user_id}, #{lv}, #{exp}"
    #     @user_data_dao.update_user_lv user_id, lv, exp
    #   end
    #   nil
    # end

    register('inc_exp_message') do |msg_map, params|
      msg = IncExpMessage.from_map msg_map
      user_id, exp = msg.user_id, msg.exp
      if exp < 200
        new_lv, new_exp = @user_exp_service.inc_user_exp user_id, exp
        [UpdateLvMessage.new(user_id, new_lv, new_exp)]
      else
        nil
      end
    end

    register('chat_message') do |msg_map, params|
      chat_msg = ChatMessage.from_map(msg_map)
      user_id = chat_msg.user_id
      user_name = chat_msg.user_name
      content = chat_msg.content
      map_id = @user_service.get_map_id user_id
      LogUtil.info "get_map_id: #{map_id}"
      broadcast_in_map map_id, chat_msg unless map_id.nil?
      @user_score_service.inc_chat_score user_id
      @chat_message_service.add_message user_id, user_name, map_id, content
      nil
    end

    register('join_message') do |msg_map, params|
      join_message = JoinMessage.from_map(msg_map)
      user_id = join_message.user_id
      user_name = join_message.user_name
      lv = join_message.lv
      map_id = join_message.map_id
      @user_service.join user_id, user_name, map_id, params[:client]
      broadcast_in_map map_id, SystemMessage.new("欢迎新成员 #{user_name} (Lv.#{lv}) 加入")
      nil
    end

    register('quit_message') do |msg_map, params|
      quit_message = QuitMessage.from_map(msg_map)
      user_id = quit_message.user_id
      user_name = quit_message.user_name
      map_id = quit_message.map_id
      @user_service.quit user_id, map_id
      broadcast_in_map map_id, quit_message
      broadcast_in_map map_id, SystemMessage.new("成员 #{user_name} 已离开")
      nil
    end

    register('role_message') do |msg_map, params|
      role_msg = RoleMessage.from_map(msg_map)
      user_id = role_msg.user_id
      map_id = @user_service.get_map_id user_id
      @user_service.update_role user_id, role_msg.role_map

      user = @user_service.get_user(user_id)
      unless user.nil?
        role_msg.role_map['food_type_id'] = user.food_type_id # todo refactor
        broadcast_in_map map_id, role_msg
      end
      nil
    end

    register('roles_query_message') do |msg_map, params|
      roles_query_msg = RolesQueryMessage.from_map(msg_map)
      map_id = roles_query_msg.map_id
      users = @user_service.get_users(map_id)
      if users.length > 0
        role_msgs = []
        users.each do |user|
          role_msg = RoleMessage.new(user.user_id, user.user_name, user.get_role_map)
          role_msgs << role_msg
        end
         role_msgs
      else
        nil
      end
    end

    register('area_items_query_message') do |msg_map, params|
      area_items_query_msg = AreaItemsQueryMessage.from_map(msg_map)
      map_id = area_items_query_msg.map_id
      area_items_dict = @area_items_service.get_area_items_by_map_id map_id
      if area_items_dict.size > 0
        area_items_msgs = []
        area_items_dict.each_pair do |area_id, items|
          items.each do |item|
            area_items_msgs << AreaItemMessage.new(area_id, item.to_map, AreaItemMessage::Action::CREATE)
          end
        end
        area_items_msgs
      else
        nil
      end
    end

    register('try_pickup_item_message') do |msg_map, params|
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

    register('discard_item_message') do |msg_map, params|
      discard_item_msg = DiscardItemMessage.from_map(msg_map)
      area_id = discard_item_msg.area_id
      item_map = discard_item_msg.item_map

      item = ItemFactory.create_item item_map
      @area_items_service.discard area_id, item
      nil
    end

    register('eating_food_message') do |msg_map, params|
      eating_food_msg = EatingFoodMessage.from_map(msg_map)
      user_id = eating_food_msg.user_id
      user = @user_service.get_user(user_id)
      unless user.nil?
        user.eating(eating_food_msg.food_map['food_type_id'])
        map_id = user.map_id
        broadcast_in_map map_id, eating_food_msg
      end
      nil
    end

    register('eat_up_food_message') do |msg_map, params|
      eat_up_food_msg = EatUpFoodMessage.from_map msg_map
      user_id = eat_up_food_msg.user_id
      user = @user_service.get_user(user_id)
      unless user.nil?
        user.eat_up
        map_id = user.map_id
        broadcast_in_map map_id, eat_up_food_msg
      end
      @user_score_service.inc_food_score(user_id)
      nil
    end

    register('hit_message') do |msg_map, params|
      hit_msg = HitMessage.from_map msg_map
      map_id = @user_service.get_map_id hit_msg.user_id
      broadcast_in_map map_id, hit_msg
      nil
    end

    register('being_battered_message') do |msg_map, params|
      being_battered_msg = BeingBatteredMessage.from_map msg_map
      map_id = @user_service.get_map_id being_battered_msg.user_id
      broadcast_in_map map_id, being_battered_msg
      nil
    end

    register('collecting_rubbish_message') do |msg_map, params|
      collecting_rubbish_msg = CollectingRubbishMessage.from_map msg_map
      map_id = @user_service.get_map_id collecting_rubbish_msg.user_id
      broadcast_in_map map_id, collecting_rubbish_msg
      nil
    end

    register('collecting_nutrient_message') do |msg_map, params|
      collecting_nutrient_msg = CollectingNutrientMessage.from_map msg_map
      map_id = @user_service.get_map_id collecting_nutrient_msg.user_id
      broadcast_in_map map_id, collecting_nutrient_msg
      nil
    end

    register('smash_large_rubbish_message') do |msg_map, params|
      msg = SmashLargeRubbishMessage.from_map msg_map
      user_id = msg.user_id
      area_id = msg.area_id
      large_rubbish_id = msg.large_rubbish_id
      map_id = @user_service.get_map_id user_id
      broadcast_in_map map_id, msg
      damage = @large_rubbish_service.smash area_id, large_rubbish_id
      exp = damage.to_i
      if exp > 0
        @user_score_service.inc_large_rubbish_score
        new_lv, new_exp = @user_exp_service.inc_user_exp user_id, exp
        [UpdateLvMessage.new(user_id, new_lv, new_exp)]
      else
        nil
      end
    end

    register('area_large_rubbishes_query_message') do |msg_map, params|
      msg = AreaLargeRubbishesQueryMessage.from_map(msg_map)
      map_id = msg.map_id
      large_rubbishes_dict = @large_rubbish_service.get_large_rubbishes_dict map_id
      if large_rubbishes_dict.size > 0
        large_rubbishes_msgs = []
        large_rubbishes_dict.each_pair do |area_id, items|
          items.each do |item|
            large_rubbishes_msgs << LargeRubbishMessage.new(area_id, item.to_map, LargeRubbishMessage::Action::CREATE)
          end
        end
        large_rubbishes_msgs
      else
        nil
      end
    end

  end

  def add_client(client)
    @map_user_count_service.inc_user_count
    @broadcast_service.add client
    LogUtil.info 'add_client done'
  end

  def delete_client(client)
    @map_user_count_service.dec_user_count
    @broadcast_service.delete client
  end

  def user_quit(client)
    user = @user_service.get_user_by_client client
    unless user.nil?
      @user_service.quit(user.user_id, user.map_id)

      quit_msg = QuitMessage.new(user.user_id, user.user_name, user.map_id)
      @broadcast_service.send(user.map_id, quit_msg.to_json)

      sys_msg = SystemMessage.new("成员 #{user.user_name} 已退出")
      @broadcast_service.send(user.map_id, sys_msg.to_json)
    end
  end

  def process(line, client)
    return nil if line.nil? || line == ''
    begin
      msg_map = JSON.parse(line)
      response_messages = process_message msg_map, client
      if response_messages.nil?
        return nil
      else
        return to_json_list(response_messages)
      end
    rescue Exception => e
      LogUtil.error "line #{line}"
      LogUtil.error e.backtrace.inspect
      return nil
    end
  end

  def process_message(msg_map, client = nil)
    @message_handler_service.process(msg_map, :client=>client)
  end

  private

  # def broadcast(msg)
  #   @broadcast_service.send_all msg.to_json
  # end

  def broadcast_in_map(map_id, msg)
    @broadcast_service.send map_id, msg.to_json
  end

  def get_text_messages(min_version)
    text_messages = []
    if min_version < 0 || min_version >= @text_messages.size
      return text_messages
    end
    begin_index = [min_version - @version_offset, 0].max
    max_index = @text_messages.size - 1 - @version_offset
    @mutex.synchronize {
      begin_index.upto(max_index) do |i|
        message = @text_messages[i]
        text_messages << message
      end
    }
    text_messages
  end

  def to_json_list(text_messages)
    text_messages.map { |m| m.to_json }
  end

  def get_new_version
    @text_messages.size + @version_offset
  end

  def register(msg_type, &handler)
    @message_handler_service.register msg_type, &handler
  end
end