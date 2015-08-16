# coding: UTF-8

require 'thread'
require_relative 'broadcast_service'
require_relative 'user_service'

class ChatRoomService
  attr_reader :text_messages

  def initialize
    autowired(UserService, BroadcastService, MessageHandlerService, AreaItemsService)
    @text_messages = []
    @mutex = Mutex.new
    @version_offset = 0
    init_message_handler
  end

  def init_message_handler
    register('chat_message') do |msg_map, params|
      chat_msg = ChatMessage.json_create(msg_map)
      user_id = chat_msg.user_id
      map_id = @user_service.get_map_id user_id
      puts "get_map_id: #{map_id}"
      broadcast_in_map map_id, chat_msg unless map_id.nil?
      nil
    end

    register('join_message') do |msg_map, params|
      join_message = JoinMessage.json_create(msg_map)
      user_id = join_message.user_id
      user_name = join_message.user_name
      map_id = join_message.map_id
      @user_service.join user_id, user_name, map_id, params[:client]
      broadcast_in_map map_id, SystemMessage.new("欢迎新成员 #{user_name} 加入")
      nil
    end

    register('quit_message') do |msg_map, params|
      quit_message = QuitMessage.json_create(msg_map)
      user_id = quit_message.user_id
      user_name = quit_message.user_name
      map_id = quit_message.map_id
      @user_service.quit user_id, map_id
      broadcast_in_map map_id, quit_message
      broadcast_in_map map_id, SystemMessage.new("成员 #{user_name} 已退出")
      nil
    end

    register('role_message') do |msg_map, params|
      role_msg = RoleMessage.json_create(msg_map)
      user_id = role_msg.user_id
      map_id = @user_service.get_map_id user_id
      @user_service.update_role user_id, role_msg.role_map
      broadcast_in_map map_id, role_msg
      nil
    end

    register('roles_query_message') do |msg_map, params|
      roles_query_msg = RolesQueryMessage.json_create(msg_map)
      map_id = roles_query_msg.map_id
      users = @user_service.get_users(map_id)
      role_msgs = []
      users.each do |user|
        role_msg = RoleMessage.new(user.user_id, user.user_name, user.role_map)
        role_msgs << role_msg
      end
      role_msgs
    end

    register('area_items_query_message') do |msg_map, params|
      area_items_query_msg = AreaItemsQueryMessage.json_create(msg_map)
      map_id = area_items_query_msg.map_id
      area_items_dict = @area_items_service.get_area_items_by_map_id map_id
      area_items_msgs = []
      area_items_dict.each_pair do |area_id, items|
        items.each do |item|
          area_items_msgs << AreaItemMessage.new(area_id, item.to_map, AreaItemMessage::Action::CREATE)
        end
      end
      area_items_msgs
    end
  end

  def add_client(client)
    @broadcast_service.add client
  end

  def delete_client(client)
    @broadcast_service.delete client
    user = @user_service.get_user_by_client client
    @user_service.quit(user.user_id, user.map_id) unless user.nil?

    quit_msg = QuitMessage.new(user.user_id, user.user_name, user.map_id)
    @broadcast_service.send(user.map_id, quit_msg.to_json)

    sys_msg = SystemMessage.new("成员 #{user.user_name} 已退出")
    @broadcast_service.send(user.map_id, sys_msg.to_json)
  end

  def process(line, client)
    return nil if line.nil? || line == ''
    msg_map = JSON.parse(line)
    response_messages = process_message msg_map, client
    return nil if response_messages.nil?
    to_json(response_messages) unless response_messages.nil?
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

  def to_json(text_messages)
    (text_messages.map { |m| m.to_json }).join("\n")
  end

  def get_new_version
    @text_messages.size + @version_offset
  end

  def register(msg_type, &handler)
    @message_handler_service.register msg_type, &handler
  end
end