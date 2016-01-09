# coding: UTF-8

class UserController < ControllerBase
  def initialize
    super
    autowired(UserDataDao, UserVehicleDao, UserRubbishService, UserNutrientService,
              UserScoreService, UserService, UserExpService,
              LargeRubbishService, MonsterService, AreaItemsService)
  end

  def init_sync_user(msg_map, params)
    init_sync_user_msg = InitSyncUserMessage.from_map(msg_map)
    user_id = init_sync_user_msg.user_id
    user_name = init_sync_user_msg.user_name
    @user_data_dao.sync_user user_id, user_name
    lv, exp = @user_data_dao.get_user_lv user_id
    vehicles = @user_vehicle_dao.get_vehicles user_id
    rubbishes = @user_rubbish_service.get_rubbishes user_id
    nutrients = @user_nutrient_service.get_nutrients user_id
    res_sync_user_msg = ResSyncUserMessage.new(user_id, lv, exp, vehicles, rubbishes, nutrients)
    [res_sync_user_msg]
  end

  def inc_exp(msg_map, params)
    msg = IncExpMessage.from_map msg_map
    user_id, food_exp_infos = msg.user_id, msg.food_exp_infos
    return nil if food_exp_infos.nil?
    sum_exp = 0
    food_exp_infos.each do |food_exp_info|
      food_id = food_exp_info['food_id']
      exp = food_exp_info['exp'].to_i
      # 验证食物当前剩余能量够扣
      LogUtil.info "food_id:#{food_id} exp:#{exp}"
      if @area_items_service.dec_food_energy(food_id, exp)
        LogUtil.info 'dec food energy ok'
        sum_exp += exp
      else
        LogUtil.info 'dec food energy wrong'
      end
    end
    if sum_exp > 0 && sum_exp < 200
      new_lv, new_exp = @user_exp_service.inc_user_exp user_id, sum_exp
      [UpdateLvMessage.new(user_id, new_lv, new_exp)]
    else
      nil
    end
  end

  def join(msg_map, params)
    join_message = JoinMessage.from_map(msg_map)
    user_id = join_message.user_id
    user_name = join_message.user_name
    lv = join_message.lv
    map_id = join_message.map_id
    @user_service.join user_id, user_name, map_id, params[:client]
    broadcast_in_map map_id, SystemMessage.new("欢迎新成员 #{user_name} (Lv.#{lv}) 加入")
    nil
  end

  def quit(msg_map, params)
    quit_message = QuitMessage.from_map(msg_map)
    user_id = quit_message.user_id
    user_name = quit_message.user_name
    map_id = quit_message.map_id
    @user_service.quit user_id, map_id
    broadcast_in_map map_id, quit_message
    broadcast_in_map map_id, SystemMessage.new("成员 #{user_name} 已离开")
    nil
  end

  def update_role(msg_map, params)
    role_msg = RoleMessage.from_map(msg_map)
    user_id = role_msg.user_id
    map_id = @user_service.get_map_id user_id
    @user_service.update_role user_id, role_msg.role_map

    user = @user_service.get_user(user_id)
    unless user.nil?
      role_msg.role_map['food_type_id'] = user.food_type_id # todo refactor
      broadcast_in_map map_id, role_msg
    end
    nil
  end

  def query_roles(msg_map, params)
    roles_query_msg = RolesQueryMessage.from_map(msg_map)
    map_id = roles_query_msg.map_id
    users = @user_service.get_users(map_id)
    if users.length > 0
      role_msgs = []
      users.each do |user|
        role_msg = RoleMessage.new(user.user_id, user.user_name, user.get_role_map)
        role_msgs << role_msg
      end
      role_msgs
    else
      nil
    end
  end

  def eating_food(msg_map, params)
    eating_food_msg = EatingFoodMessage.from_map(msg_map)
    user_id = eating_food_msg.user_id
    user = @user_service.get_user(user_id)
    unless user.nil?
      user.eating(eating_food_msg.food_map['food_type_id'])
      map_id = user.map_id
      broadcast_in_map map_id, eating_food_msg
    end
    nil
  end

  def eat_up_food(msg_map, params)
    eat_up_food_msg = EatUpFoodMessage.from_map msg_map
    user_id = eat_up_food_msg.user_id
    user = @user_service.get_user(user_id)
    unless user.nil?
      user.eat_up
      map_id = user.map_id
      broadcast_in_map map_id, eat_up_food_msg
    end
    @user_score_service.inc_food_score(user_id)
    nil
  end

  def hit(msg_map, params)
    hit_msg = HitMessage.from_map msg_map
    map_id = @user_service.get_map_id hit_msg.user_id
    broadcast_in_map map_id, hit_msg
    nil
  end

  def being_battered(msg_map, params)
    being_battered_msg = BeingBatteredMessage.from_map msg_map
    map_id = @user_service.get_map_id being_battered_msg.user_id
    broadcast_in_map map_id, being_battered_msg
    nil
  end

  def collecting_rubbish(msg_map, params)
    collecting_rubbish_msg = CollectingRubbishMessage.from_map msg_map
    map_id = @user_service.get_map_id collecting_rubbish_msg.user_id
    broadcast_in_map map_id, collecting_rubbish_msg
    nil
  end

  def collecting_nutrient(msg_map, params)
    collecting_nutrient_msg = CollectingNutrientMessage.from_map msg_map
    map_id = @user_service.get_map_id collecting_nutrient_msg.user_id
    broadcast_in_map map_id, collecting_nutrient_msg
    nil
  end

  def smash_large_rubbish(msg_map, params)
    msg = SmashLargeRubbishMessage.from_map msg_map
    user_id = msg.user_id
    area_id = msg.area_id
    large_rubbish_id = msg.large_rubbish_id
    map_id = @user_service.get_map_id user_id
    broadcast_in_map map_id, msg
    damage = @large_rubbish_service.smash area_id, large_rubbish_id
    exp = damage.to_i
    if exp > 0
      @user_score_service.inc_large_rubbish_score user_id
      new_lv, new_exp = @user_exp_service.inc_user_exp user_id, exp
      [UpdateLvMessage.new(user_id, new_lv, new_exp)]
    else
      nil
    end
  end

  def smash_monster_message(msg_map, params)
    msg = SmashMonsterMessage.from_map msg_map
    user_id = msg.user_id
    area_id = msg.area_id
    monster_id = msg.monster_id
    map_id = @user_service.get_map_id user_id
    broadcast_in_map map_id, msg
    damage = @monster_service.smash area_id, monster_id
    exp = damage.to_i * 3 # 攻击野怪经验
    if exp > 0
      @user_score_service.inc_monster_score user_id
      new_lv, new_exp = @user_exp_service.inc_user_exp user_id, exp
      [UpdateLvMessage.new(user_id, new_lv, new_exp)]
    else
      nil
    end
  end

  def pet_attack_enemy_message(msg_map, params)
    msg = PetAttackEnemyMessage.from_map msg_map
    user_id = msg.user_id
    area_id = msg.area_id
    enemy_id = msg.enemy_id

    case msg.enemy_type
      when 'large_rubbish'
        damage = @large_rubbish_service.smash area_id, enemy_id
      when 'monster'
        damage = @monster_service.smash area_id, enemy_id
      else
        return nil
    end

    exp = damage.to_i
    if exp > 0
      new_lv, new_exp = @user_exp_service.inc_user_exp user_id, exp
      [UpdateLvMessage.new(user_id, new_lv, new_exp)]
    else
      nil
    end
  end

  def query_area_enemies(msg_map, params)
    msg = AreaLargeRubbishesQueryMessage.from_map(msg_map)
    map_id = msg.map_id
    large_rubbishes_dict = @large_rubbish_service.get_large_rubbishes_dict map_id
    monsters_dict = @monster_service.get_monsters_dict map_id

    enemies_msgs = []

    large_rubbishes_dict.each_pair do |area_id, items|
      items.each do |item|
        enemies_msgs << LargeRubbishMessage.new(area_id, item.to_map, LargeRubbishMessage::Action::CREATE)
      end
    end

    monsters_dict.each_pair do |area_id, items|
      items.each do |item|
        enemies_msgs << MonsterMessage.new(area_id, item.to_map, MonsterMessage::Action::CREATE)
      end
    end

    enemies_msgs
  end
end