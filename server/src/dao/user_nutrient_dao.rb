class UserNutrientDao
  NUTRIENTS_COUNT = 3

  def initialize
    autowired(DbConnectionPool)
  end

  def get_my
    @db_connection_pool.get_conn
  end

  def clear
    get_my.query('delete from v1_user_nutrients')
  end

  def count
    r = get_my.query('select count(*) from v1_user_nutrients').fetch
    r[0].to_i
  end

  def has_nutrient?(user_id, type_id)
    r = get_my.prepare('select user_id from v1_user_nutrients where user_id = ? and type_id = ?')
            .execute(user_id, type_id).fetch
    !r.nil? && r.size > 0
  end

  def create_nutrient(user_id, type_id)
    stmt = get_my.prepare('insert into v1_user_nutrients(user_id, type_id, count) values(?, ?, 0)')
    stmt.execute user_id, type_id
  end

  def add_nutrient(user_id, type_id)
    stmt = get_my.prepare('update v1_user_nutrients set count = count + 1 where user_id = ? and type_id = ?')
    stmt.execute user_id, type_id
  end

  def get_nutrients(user_id)
    nutrients = []
    NUTRIENTS_COUNT.times {
      nutrients << 0
    }
    get_my.prepare('select type_id, count from v1_user_nutrients where user_id = ? order by type_id asc')
        .execute(user_id).each do |r|
      type_id = r[0].to_i
      count = r[1].to_i
      nutrients[type_id] = count
    end
    nutrients
  end
end