class User
  attr_reader :user_id, :user_name, :map_id, :client
  attr_accessor :role_map, :food_type_id

  def initialize(user_id, user_name, map_id, role_map, client)
    @user_id = user_id
    @user_name = user_name
    @map_id = map_id
    @role_map = role_map
    @client = client
    @food_type_id = -1
  end

  def eating(food_type_id)
    @food_type_id = food_type_id
  end

  def eat_up
    @food_type_id = -1
  end

  def get_role_map
    @role_map['food_type_id'] = @food_type_id
    @role_map
  end

  def wears
    {
        vehicle: role_map['vehicle'],
        wing: role_map['wing'],
        hat: role_map['hat'],
        eye_wear: role_map['eye_wear']
    }
  end
end