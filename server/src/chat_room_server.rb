# coding: UTF-8
$:.unshift(File.dirname(__FILE__))

require 'socket'
require 'mysql'
require 'json'
require 'utils/des'
require 'utils/log_util'
require 'engine/dependency_injection'

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
require 'messages/collecting_rubbish_message'
require 'messages/collecting_nutrient_message'
require 'messages/map_user_count_message'
require 'messages/large_rubbish_message'
require 'messages/smash_large_rubbish_message'
require 'messages/area_large_rubbishes_query_message'
require 'messages/inc_exp_message'
require 'messages/pet_message'
require 'messages/monster_message'
require 'messages/area_enemies_query_message'
require 'messages/smash_monster_message'
require 'messages/pet_attack_enemy_message'

require 'models/user'
require 'models/area'
require 'models/item'
require 'models/food'
require 'models/rubbish'
require 'models/nutrient'
require 'models/exp_tool'
require 'models/enemy'
require 'models/large_rubbish'
require 'models/monster'

require 'dao/db_connection_pool'
require 'dao/dao_base'
require 'dao/user_data_dao'
require 'dao/user_vehicle_dao'
require 'dao/user_rubbish_dao'
require 'dao/user_nutrient_dao'
require 'dao/user_score_dao'
require 'dao/chat_message_dao'

require 'services/item_factory'
require 'services/user_exp_service'
require 'services/message_handler_service'
require 'services/chat_room_service'
require 'services/broadcast_service'
require 'services/user_service'
require 'services/map_service'
require 'services/area_items_service'
require 'services/user_data_service'
require 'services/user_rubbish_service'
require 'services/user_nutrient_service'
require 'services/command_service'
require 'services/encryption_service'
require 'services/map_user_count_service'
require 'services/large_rubbish_service'
require 'services/user_score_service'
require 'services/chat_message_service'
require 'services/monster_service'

require 'controllers/controller_base'
require 'controllers/command_controller'
require 'controllers/chat_controller'
require 'controllers/user_controller'
require 'controllers/area_item_controller'
require 'controllers/pet_controller'


class ChatRoomServer
  def initialize
    autowired(ChatRoomService, BroadcastService, UserService,
              MapService, AreaItemsService, EncryptionService)
    @mutex = Mutex.new
    @thread_count = 0
  end

  def init
    # server = TCPServer.open(2003)
    # loop {
    Socket.tcp_server_loop(2008) do |client, client_addrinfo|
      # Thread.start(server.accept) do |client|
      Thread.new {
        begin
          @mutex.synchronize {
            @thread_count += 1
            LogUtil.info "thread count: #{@thread_count}"
          }
          accept client
          client.close
        rescue Exception => e
          LogUtil.error 'Thread.start proc raise exception:'
          LogUtil.error e.backtrace.inspect
        ensure
          @mutex.synchronize {
            @thread_count -= 1
            LogUtil.info "thread count: #{@thread_count}"
          }
        end
      }
      # end
    # }
    end
  end

  private

  def accept(client)
    begin
      des = @encryption_service.new_client_des client
      client.puts(des.password + "\n")
      LogUtil.info 'accept @chat_room_service.add_client'
      @chat_room_service.add_client client
      LogUtil.info "password:#{des.password} start readline loop"
      while (line = client.readline)
        next if line.nil?
        line = line.chomp
        line.gsub! /\n|\r/, ''
        line = des.decrypt line
        # LogUtil.info line
        begin
          response_messages = @chat_room_service.process line, client
          next if response_messages.nil? || response_messages.length == 0
          response_messages.each do |msg|
            @encryption_service.puts_data(client, msg)
          end
        rescue Exception => e
          LogUtil.error e.backtrace.inspect
          return
        end
      end
    rescue Exception => e
      LogUtil.error 'accept client raise exception:'
      LogUtil.error e.backtrace.inspect
    ensure
      LogUtil.info 'accept_ensure_start'
      @chat_room_service.user_quit client
      @encryption_service.delete_client_des client
      @chat_room_service.delete_client client
      LogUtil.info 'accept_ensure_done'
    end
  end
end

server = ChatRoomServer.new
server.init