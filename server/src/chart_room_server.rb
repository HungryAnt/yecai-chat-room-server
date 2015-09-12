# coding: UTF-8
$:.unshift(File.dirname(__FILE__))

require 'socket'
require 'mysql'
require 'json'
require 'engine/dependency_injection'
require 'utils/des'

require 'config/database_config'

require 'messages/init_sync_user_message'
require 'messages/res_sync_user_message'
require 'messages/update_lv_message'
require 'messages/query_message'
require 'messages/text_message'
require 'messages/chat_message'
require 'messages/system_message'
require 'messages/join_message'
require 'messages/quit_message'
require 'messages/role_message'
require 'messages/roles_query_message'
require 'messages/area_item_message'
require 'messages/area_items_query_message'
require 'messages/try_pickup_item_message'
require 'messages/discard_item_message'
require 'messages/eating_food_message'
require 'messages/eat_up_food_message'
require 'messages/command_message'
require 'messages/hit_message'
require 'messages/being_battered_message'

require 'models/user'
require 'models/area'
require 'models/food'

require 'dao/db_connection_pool'
require 'dao/user_data_dao'
require 'dao/user_vehicle_dao'

require 'services/item_factory'
require 'services/message_handler_service'
require 'services/chat_room_service'
require 'services/broadcast_service'
require 'services/user_service'
require 'services/map_service'
require 'services/area_items_service'
require 'services/user_data_service'
require 'services/command_service'
require 'services/encryption_service'


class ChartRoomServer
  def initialize
    autowired(ChatRoomService, BroadcastService, UserService,
              MapService, AreaItemsService, EncryptionService)
  end

  def init
    init_broadcast
    server = TCPServer.open(2002)
    loop {
      Thread.start(server.accept) do |client|
        @chat_room_service.add_client client
        begin
          accept client
        rescue Exception => e
          puts 'accept client raise exception:'
          puts e.message
          puts e.backtrace.inspect
        end
        @chat_room_service.delete_client client
      end
    }
  end

  private

  def init_broadcast
    @broadcast_service.init_send_proc do |client, msg_text|
      begin
        des = @encryption_service.get_des(client)
        puts_data(client, msg_text, des)
      rescue Exception => e
        puts 'broadcast send message raise exception:'
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end

  def accept(client)
    des = @encryption_service.new_client_des client
    client.puts(des.password + "\n")
    while (line = client.readline)
      next if line.nil?
      line = line.chomp
      line.gsub! /\n|\r/, ''
      line = des.decrypt line
      # puts line
      begin
        response_messages = @chat_room_service.process line, client
        next if response_messages.nil? || response_messages.length == 0
        response_messages.each do |msg|
          puts_data(client, msg, des)
        end
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
      # client.puts(Time.now.ctime) # 发送时间到客户端
      # client.puts "Closing the connection. Bye!"
    client.close
  end

  def puts_data(client, data, des)
    client.puts(des.encrypt(data) + "\n") unless des.nil?
  end
end

server = ChartRoomServer.new
server.init