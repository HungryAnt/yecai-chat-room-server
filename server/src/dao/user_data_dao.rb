class UserDataDao
  def initialize
    @my = Mysql.connect(DatabaseConfig::HOST, 'root', 'ant', 'yecai', 3306)
  end

  def clear
    @my.query('delete from v1_users')
  end

  def sync_user(user_id, user_name)
    if has_user? user_id
      update_user_name user_id, user_name
    else
      create_user user_id, user_name
    end
  end

  def create_user(user_id, user_name)
    stmt = @my.prepare('insert into v1_users(user_id, user_name) values(?, ?)')
    stmt.execute user_id, user_name
  end

  def has_user?(user_id)
    users = @my.prepare('select user_id from v1_users where user_id = ?').execute(user_id).fetch
    !users.nil? && users.size == 1
  end

  def update_user_name(user_id, user_name)
    @my.prepare('update v1_users set user_name = ? where user_id = ?')
        .execute(user_name, user_id)
  end

  def get_user_lv(user_id)
    r = @my.prepare('select lv, exp from v1_users where user_id = ?').execute(user_id).fetch
    return r[0].to_i, r[1].to_i
  end

  def update_user_lv(user_id, lv, exp)
    @my.prepare('update v1_users set lv = ?, exp = ? where user_id = ?')
        .execute(lv, exp, user_id)
  end
end