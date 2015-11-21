class PetController < ControllerBase
  def initialize

  end

  def update_pet(msg_map, params)
    msg = PetMessage.from_map msg_map
    
    nil
  end
end