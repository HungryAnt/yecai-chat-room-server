# coding: UTF-8

require 'thread'
require_relative 'broadcast_service'
require_relative 'user_service'

class ChatRoomService
  attr_reader :text_messages

  def initialize
    @text_messages = []
    @mutex = Mutex.new
    @version_offset = 0
  end

  def process(line, client)
    return nil if line.nil? || line == ''
    raw_massage_map = JSON.parse(line)
    response_messages = process_message raw_massage_map, client
    return nil if response_messages.nil?
    to_json(response_messages) unless response_messages.nil?
  end

  def process_message(raw_massage_map, client = nil)
    case raw_massage_map['type']
      when 'text_message'
        text_message = TextMessage.json_create(raw_massage_map)
        @mutex.synchronize {
          text_message.version = get_new_version
          @text_messages << text_message
        }
      when 'query_message'
        query_message = QueryMessage.json_create(raw_massage_map)
        return get_text_messages(query_message.version)
      when 'join_message'
        join_message = JoinMessage.json_create(raw_massage_map)
        user_id = join_message.user_id
        user_name = join_message.user_name
        user_service = get_instance(UserService)
        user_service.add client, user_id, user_name
        system_message = SystemMessage.new "欢迎新成员 #{user_name} 加入"
        broadcast system_message
      when 'quit_message'
        quit_message = QuitMessage.json_create(raw_massage_map)
        user_name = quit_message.user_name
        system_message = SystemMessage.new "成员 #{user_name} 已退出"
        broadcast system_message
      else
        # type code here
    end
    nil
  end

  private

  def broadcast(message)
    broadcast_service = get_instance(BroadcastService)
    broadcast_service.send message.to_json
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
end