class User
  attr_reader :user_id, :user_name, :map_id, :client

  def initialize(user_id, user_name, map_id, client)
    @user_id = user_id
    @user_name = user_name
    @map_id = map_id
    @client = client
  end
end