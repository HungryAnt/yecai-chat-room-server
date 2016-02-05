# coding: UTF-8

require 'thread'
require_relative 'broadcast_service'
require_relative 'user_service'

class ChatRoomService
  attr_reader :text_messages

  def initialize
    autowired(UserService, BroadcastService, MessageHandlerService,
              MapUserCountService)
    @text_messages = []
    @mutex = Mutex.new
    @version_offset = 0
    init_message_handler
  end

  def bind(msg_type, clazz, action)
    controller = get_instance clazz
    method = controller.method action
    register(msg_type) do |msg_map, params|
      method.call msg_map, params
    end
  end

  def init_message_handler
    bind 'command_message', CommandController, :command

    bind 'init_sync_user_message', UserController, :init_sync_user

    bind 'inc_exp_message', UserController, :inc_exp

    bind 'chat_message', ChatController, :chat

    bind 'join_message', UserController, :join

    bind 'quit_message', UserController, :quit

    bind 'role_message', UserController, :update_role

    bind 'roles_query_message', UserController, :query_roles

    bind 'area_items_query_message', AreaItemController, :query_area_items

    bind 'try_pickup_item_message', AreaItemController, :try_pickup_item

    bind 'discard_item_message', AreaItemController, :discard_item

    bind 'eating_food_message', UserController, :eating_food

    bind 'eat_up_food_message', UserController, :eat_up_food

    bind 'hit_message', UserController, :hit

    bind 'being_battered_message', UserController, :being_battered

    bind 'collecting_rubbish_message', UserController, :collecting_rubbish

    bind 'collecting_nutrient_message', UserController, :collecting_nutrient

    bind 'smash_large_rubbish_message', UserController, :smash_large_rubbish

    bind 'smash_monster_message', UserController, :smash_monster_message

    bind 'pet_attack_enemy_message', UserController, :pet_attack_enemy_message

    bind 'area_enemies_query_message', UserController, :query_area_enemies

    bind 'pet_message', PetController, :update_pet

    bind 'shit_mine_message', ShitMineController, :add_shit_mine

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