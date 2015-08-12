class User
  attr_reader :user_id, :user_name, :map_id, :area_id, :role_map, :client

  def initialize(user_id, user_name, map_id, area_id, role_map, client)
    @user_id = user_id
    @user_name = user_name
    @map_id = map_id
    @area_id = area_id
    @role_map = role_map
    @client = client
  end
end