class User
  attr_reader :user_id, :user_name, :map_id, :client
  attr_accessor :role_map

  def initialize(user_id, user_name, map_id, role_map, client)
    @user_id = user_id
    @user_name = user_name
    @map_id = map_id
    @role_map = role_map
    @client = client
  end
end