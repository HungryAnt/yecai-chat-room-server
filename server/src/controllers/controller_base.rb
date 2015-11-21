class ControllerBase
  def initialize
    autowired(BroadcastService)
  end

  def broadcast_in_map(map_id, msg)
    @broadcast_service.send map_id, msg.to_json
  end
end