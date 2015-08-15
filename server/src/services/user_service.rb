class UserService
  def initialize
    @map_user_dict = {}
    @all_user_dict = {}
    @mutex = Mutex.new
  end

  def join(user_id, user_name, map_id, client)
    @mutex.synchronize {
      user_dict = @map_user_dict[map_id] || {}
      @map_user_dict[map_id] = user_dict
      return if user_dict.include? user_id
      user = User.new(user_id, user_name, map_id, nil, client)
      user_dict[user_id] = @all_user_dict[user_id] = user
    }
  end

  def quit(user_id, map_id)
    @mutex.synchronize {
      user_dict = @map_user_dict[map_id]
      return if user_dict.nil?
      user_dict.delete_if {|k, v| k == user_id}
      @all_user_dict.delete_if {|k, v| k == user_id}
    }
  end

  def get_clients(map_id)
    @mutex.synchronize {
      return [] unless @map_user_dict.include? map_id
      user_dict = @map_user_dict[map_id]
      return user_dict.values.map {|user| user.client}
    }
  end

  def get_map_id(user_id)
    @mutex.synchronize {
      return nil unless @all_user_dict.include? user_id
      return @all_user_dict[user_id].map_id
    }
  end

  def update_role(user_id, role_map)
    user = @all_user_dict[user_id]
    user.role_map = role_map unless user.nil?
  end

  def get_users(map_id)
    @mutex.synchronize {
      user_dict = @map_user_dict[map_id]
      return [] if user_dict.nil?
      users = []
      user_dict.each_value do |user|
        users << user unless user.role_map.nil?
      end
      return users
    }
  end

  def get_user_by_client(client)
    @mutex.synchronize {
      return @all_user_dict.values.find {|user| user.client == client}
    }
  end
end