class ShitMineService
  def initialize
    autowired(MapService, BroadcastService, ShitMineDao)
    @mutex = Mutex.new
    @shit_mines = []
    init_thread
  end

  def init_thread
    Thread.new {
      sleep(1)

      loop {
        begin
          process_bomb
        rescue Exception => e
          LogUtil.error 'shit mine process raise exception:'
          LogUtil.error e.backtrace.inspect
        end
        sleep(0.1)
      }
    }
  end

  def add(shit_mine_message)
    shit_mine_id = SecureRandom.uuid
    user_id = shit_mine_message.user_id
    shit_mine_message.id = shit_mine_id
    shit_mine = ShitMine.new shit_mine_id, user_id,
                             shit_mine_message.area_id, shit_mine_message.x, shit_mine_message.y
    @mutex.synchronize {
      @shit_mines << shit_mine
    }

    notify_shit_mine_setup shit_mine_message
    @shit_mine_dao.decrease_shit_mine user_id
  end

  def process_bomb
    @mutex.synchronize {
      bomb_mines = []
      @shit_mines.reject! do |mine|
        if mine.bomb?
          bomb_mines << mine
          true
        else
          false
        end
      end

      bomb_mines.each do |shit_mine|
        notify_shit_mine_bomb shit_mine
      end
    }
  end

  private

  def notify_shit_mine_setup(shit_mine_message)
    area = @map_service.get_area(shit_mine_message.area_id)
    return if area.nil?
    @broadcast_service.send area.map_id, shit_mine_message.to_json
  end

  def notify_shit_mine_bomb(shit_mine)
    area = @map_service.get_area(shit_mine.area_id)
    return if area.nil?
    shit_mine_msg = ShitMineMessage.new(shit_mine.id, shit_mine.user_id, shit_mine.area_id,
                                        shit_mine.x, shit_mine.y, ShitMineMessage::BOMB)
    @broadcast_service.send area.map_id, shit_mine_msg.to_json
  end
end