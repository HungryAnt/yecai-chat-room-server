class ShitMineController
  def initialize
    autowired(ShitMineService)
  end

  def add_shit_mine(msg_map, params)
    shit_mine_message = ShitMineMessage.from_map msg_map
    @shit_mine_service.add shit_mine_message
  end
end