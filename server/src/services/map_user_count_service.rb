class MapUserCountService
  def initialize
    autowired(BroadcastService, UserService, LargeRubbishService,
              MonsterService)
    @all_user_count = 0
    @mutex = Mutex.new
    init_sync_map_user_count_thread
  end

  def init_sync_map_user_count_thread
    Thread.new {
      sleep(1)
      loop {
        begin
          sync_map_user_count
          sleep(3)
        rescue Exception => e
          LogUtil.error 'get_messages raise exception:'
          LogUtil.error e.backtrace.inspect
        end
      }
    }
  end

  def inc_user_count
    @mutex.synchronize {
      @all_user_count += 1
    }
  end

  def dec_user_count
    @mutex.synchronize {
      @all_user_count -= 1
    }
  end

  def sync_map_user_count
    map_user_count_dict = @user_service.get_map_user_count_dict
    map_large_rubbish_dict = @large_rubbish_service.get_map_large_rubbish_dict
    map_monster_dict = @monster_service.get_map_monster_dict
    map_user_count_msg = MapUserCountMessage.new(
        map_user_count_dict, @all_user_count, map_large_rubbish_dict, map_monster_dict)
    @broadcast_service.send_all map_user_count_msg.to_json
  end
end