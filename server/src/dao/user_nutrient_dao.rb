class UserNutrientDao < DaoBase
  NUTRIENTS_COUNT = 3

  def clear
    execute do |conn|
      conn.query('delete from v1_user_nutrients')
    end
  end

  def count
    r = nil
    execute do |conn|
      r = conn.query('select count(*) from v1_user_nutrients').fetch
    end
    r[0].to_i
  end

  def has_nutrient?(user_id, type_id)
    r = nil
    execute do |conn|
      r = conn.prepare('select user_id from v1_user_nutrients where user_id = ? and type_id = ?')
              .execute(user_id, type_id).fetch
    end
    !r.nil? && r.size > 0
  end

  def create_nutrient(user_id, type_id)
    execute do |conn|
      stmt = conn.prepare('insert into v1_user_nutrients(user_id, type_id, count) values(?, ?, 0)')
      stmt.execute user_id, type_id
    end
  end

  def add_nutrient(user_id, type_id)
    execute do |conn|
      stmt = conn.prepare('update v1_user_nutrients set count = count + 1 where user_id = ? and type_id = ?')
      stmt.execute user_id, type_id
    end
  end

  def get_nutrients(user_id)
    nutrients = []
    NUTRIENTS_COUNT.times {
      nutrients << 0
    }
    execute do |conn|
      conn.prepare('select type_id, count from v1_user_nutrients where user_id = ? order by type_id asc')
          .execute(user_id).each do |r|
        type_id = r[0].to_i
        count = r[1].to_i
        nutrients[type_id] = count
      end
    end
    nutrients
  end
end