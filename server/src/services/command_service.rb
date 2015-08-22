class CommandService
  def initialize
    autowired(UserService, AreaItemsService)
  end

  def process(cmd_msg)
    cmd = cmd_msg.cmd

    # 食物发放
    md = /^rand food\s*(\d*)/.match(cmd)
    unless md.nil?
      if md[1] == ''
        rand_food cmd_msg
      else
        count = md[1].to_i
        rand_many_food cmd_msg, count
      end
    end
  end

  def rand_food(cmd_msg)
    user_id = cmd_msg.user_id
    user = @user_service.get_user(user_id)
    x, y = user.role_map['x'].to_i, user.role_map['y'].to_i
    @area_items_service.cmd_rand_food(cmd_msg.area_id, x, y)
  end

  def rand_many_food(cmd_msg, count)
    @area_items_service.cmd_rand_many_food(cmd_msg.area_id, count)
  end
end