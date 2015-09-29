class UserRubbishDao
  RUBBISHES_COUNT = 12

  def initialize
    autowired(DbConnectionPool)
  end

  def get_my
    @db_connection_pool.get_conn
  end

  def clear
    get_my.query('delete from v1_user_rubbishes')
  end

  def count
    r = get_my.query('select count(*) from v1_user_rubbishes').fetch
    r[0].to_i
  end

  def has_rubbish?(user_id, type_id)
    r = get_my.prepare('select user_id from v1_user_rubbishes where user_id = ? and type_id = ?')
            .execute(user_id, type_id).fetch
    !r.nil? && r.size > 0
  end

  def create_rubbish(user_id, type_id)
    stmt = get_my.prepare('insert into v1_user_rubbishes(user_id, type_id, count) values(?, ?, 0)')
    stmt.execute user_id, type_id
  end

  def add_rubbish(user_id, type_id)
    stmt = get_my.prepare('update v1_user_rubbishes set count = count + 1 where user_id = ? and type_id = ?')
    stmt.execute user_id, type_id
  end

  def get_rubbishes(user_id)
    rubbishes = []
    RUBBISHES_COUNT.times {
      rubbishes << 0
    }
    get_my.prepare('select type_id, count from v1_user_rubbishes where user_id = ? order by type_id asc')
        .execute(user_id).each do |r|
      type_id = r[0].to_i
      count = r[1].to_i
      rubbishes[type_id] = count
    end
    rubbishes
  end
end