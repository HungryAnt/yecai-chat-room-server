class UserDataDao
  def initialize
    autowired(DbConnectionPool)
  end

  def get_my
    @db_connection_pool.get_conn
  end

  def clear
    get_my.query('delete from v1_users')
  end

  def sync_user(user_id, user_name)
    if has_user? user_id
      update_user_name user_id, user_name
    else
      create_user user_id, user_name
    end
  end

  def create_user(user_id, user_name)
    stmt = get_my.prepare('insert into v1_users(user_id, user_name) values(?, ?)')
    stmt.execute user_id, user_name
  end

  def has_user?(user_id)
    users = get_my.prepare('select user_id from v1_users where user_id = ?').execute(user_id).fetch
    !users.nil? && users.size == 1
  end

  def update_user_name(user_id, user_name)
    get_my.prepare('update v1_users set user_name = ? where user_id = ?')
        .execute(user_name, user_id)
  end

  def get_user_lv(user_id)
    r = get_my.prepare('select lv, exp from v1_users where user_id = ?').execute(user_id).fetch
    return r[0].to_i, r[1].to_i
  end

  def update_user_lv(user_id, lv, exp)
    get_my.prepare('update v1_users set lv = ?, exp = ? where user_id = ?')
        .execute(lv, exp, user_id)
  end

  def get_users_where_lv_greater_than(filter_lv)
    user_ids = []
    get_my.prepare('select user_id, lv from v1_users where lv >= ?').execute(filter_lv).each do |user_id, lv|
      puts "user_id: #{user_id}, lv: #{lv}"
      user_ids << user_id
    end
    user_ids
  end
end