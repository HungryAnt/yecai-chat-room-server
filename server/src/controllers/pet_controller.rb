class PetController < ControllerBase
  def initialize
    super
  end

  def update_pet(msg_map, params)
    pet_msg = PetMessage.from_map msg_map
    map_id = pet_msg.map_id
    broadcast_in_map map_id, pet_msg
    nil
  end
end