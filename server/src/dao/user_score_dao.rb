require_relative 'dao_base'

class UserScoreDao < DaoBase
  def has_record?(user_id)
    r = nil
    execute do |conn|
      r = conn.prepare('select user_id from v1_user_scores where user_id = ?')
              .execute(user_id).fetch
    end
    !r.nil? && r.size > 0
  end

  def create_record(user_id)
    execute do |conn|
      sql = 'insert into v1_user_scores(user_id, food_score,
rubbish_score, large_rubbish_score, monster_score, chat_score, nutrient_score)
values(?, 0, 0, 0, 0, 0, 0)'
      stmt = conn.prepare(sql)
      stmt.execute user_id
    end
  end

  def inc_score(user_id, column)
    execute do |conn|
      sql = "update v1_user_scores set #{column} = #{column} + 1 where user_id = ?"
      stmt = conn.prepare(sql)
      stmt.execute user_id
    end
  end
end