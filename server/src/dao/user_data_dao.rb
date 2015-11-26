class UserDataDao < DaoBase
  def clear
    execute do |conn|
      conn.query('delete from v1_users')
    end
  end

  def sync_user(user_id, user_name)
    if has_user? user_id
      update_user_name user_id, user_name
    else
      create_user user_id, user_name
    end
  end

  def create_user(user_id, user_name)
    execute do |conn|
      stmt = conn.prepare('insert into v1_users(user_id, user_name) values(?, ?)')
      stmt.execute user_id, user_name
    end
  end

  def has_user?(user_id)
    users = nil
    execute do |conn|
      users = conn.prepare('select user_id from v1_users where user_id = ?').execute(user_id).fetch
    end
    !users.nil? && users.size == 1
  end

  def update_user_name(user_id, user_name)
    execute do |conn|
      conn.prepare('update v1_users set user_name = ? where user_id = ?')
          .execute(user_name, user_id)
    end
  end

  def get_user_lv(user_id)
    r = nil
    execute do |conn|
      r = conn.prepare('select lv, exp from v1_users where user_id = ?').execute(user_id).fetch
    end
    return r[0].to_i, r[1].to_i
  end

  def update_user_lv(user_id, lv, exp)
    execute do |conn|
      conn.prepare('update v1_users set lv = ?, exp = ? where user_id = ?')
          .execute(lv, exp, user_id)
    end
  end

  def get_users_where_lv_greater_than(filter_lv)
    user_ids = []
    execute do |conn|
      conn.prepare('select user_id, lv from v1_users where lv >= ?').execute(filter_lv).each do |user_id, lv|
        LogUtil.info "user_id: #{user_id}, lv: #{lv}"
        user_ids << user_id
      end
    end
    user_ids
  end
end