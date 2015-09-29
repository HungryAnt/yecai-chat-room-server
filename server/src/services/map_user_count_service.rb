class MapUserCountService
  def initialize
    autowired(BroadcastService, UserService)
    init_sync_map_user_count_thread
  end

  def init_sync_map_user_count_thread
    Thread.new {
      sleep(1)
      begin
        sync_map_user_count
        sleep(10)
      rescue Exception => e
        puts 'get_messages raise exception:'
        puts e.backtrace.inspect
      end
    }
  end

  def sync_map_user_count
    map_user_count_dict = @user_service.get_map_user_count_dict
    map_user_count_msg = MapUserCountMessage.new(map_user_count_dict)
    @broadcasht_service.send_all map_user_count_msg.to_json
  end
end