class UserRubbishDao < DaoBase
  RUBBISHES_COUNT = 12

  def clear
    execute do |conn|
      conn.query('delete from v1_user_rubbishes')
    end
  end

  def count
    r = nil
    execute do |conn|
      r = conn.query('select count(*) from v1_user_rubbishes').fetch
    end
    r[0].to_i
  end

  def has_rubbish?(user_id, type_id)
    r = nil
    execute do |conn|
      r = conn.prepare('select user_id from v1_user_rubbishes where user_id = ? and type_id = ?')
              .execute(user_id, type_id).fetch
    end
    !r.nil? && r.size > 0
  end

  def create_rubbish(user_id, type_id)
    execute do |conn|
      stmt = conn.prepare('insert into v1_user_rubbishes(user_id, type_id, count) values(?, ?, 0)')
      stmt.execute user_id, type_id
    end
  end

  def add_rubbish(user_id, type_id)
    execute do |conn|
      stmt = conn.prepare('update v1_user_rubbishes set count = count + 1 where user_id = ? and type_id = ?')
      stmt.execute user_id, type_id
    end
  end

  def get_rubbishes(user_id)
    rubbishes = []
    RUBBISHES_COUNT.times {
      rubbishes << 0
    }
    execute do |conn|
      conn.prepare('select type_id, count from v1_user_rubbishes where user_id = ? order by type_id asc')
          .execute(user_id).each do |r|
        type_id = r[0].to_i
        count = r[1].to_i
        rubbishes[type_id] = count
      end
    end
    rubbishes
  end
end