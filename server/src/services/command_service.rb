class CommandService
  def initialize
    autowired(UserService, AreaItemsService)
  end

  def process(cmd_msg)
    cmd = cmd_msg.cmd

    # 食物发放 rand food
    md = /^rf\s*(\d*)/.match(cmd)
    unless md.nil?
      if md[1] == ''
        rand_food cmd_msg
      else
        count = md[1].to_i
        rand_many_food cmd_msg, count
      end
      return
    end

    # 垃圾发放 rand rubbish
    md = /^rr\s*(\d*)/.match(cmd)
    unless md.nil?
      if md[1] == ''
        rand_rubbish cmd_msg
      else
        count = md[1].to_i
        rand_many_rubbish cmd_msg, count
      end
      return
    end
  end

  private

  def rand_food(cmd_msg)
    x, y = get_user_location cmd_msg.user_id
    @area_items_service.cmd_rand_food(cmd_msg.area_id, x, y)
  end

  def rand_many_food(cmd_msg, count)
    @area_items_service.cmd_rand_many_food(cmd_msg.area_id, count)
  end

  def rand_rubbish(cmd_msg)
    x, y = get_user_location cmd_msg.user_id
    @area_items_service.cmd_rand_rubbish(cmd_msg.area_id, x, y)
  end

  def rand_many_rubbish(cmd_msg, count)
    @area_items_service.cmd_rand_many_rubbish(cmd_msg.area_id, count)
  end

  def get_user_location(user_id)
    user = @user_service.get_user(user_id)
    [user.role_map['x'].to_i, user.role_map['y'].to_i]
  end
end