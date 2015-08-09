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
      user = User.new(user_id, user_name, map_id, client)
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
end