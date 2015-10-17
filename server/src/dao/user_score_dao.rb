require_relative 'dao_base'

class UserScoreDao < DaoBase
  def has_record?(user_id)
    r = get_my.prepare('select user_id from v1_user_scores where user_id = ?')
            .execute(user_id).fetch
    !r.nil? && r.size > 0
  end

  def create_record(user_id)
    sql = 'insert into v1_user_scores(user_id, food_score,
    rubbish_score, large_rubbish_score, chat_score, nutrient_score)
    values(?, 0, 0, 0, 0, 0)'
    stmt = get_my.prepare(sql)
    stmt.execute user_id
  end

  def inc_score(user_id, column)
    sql = "update v1_user_scores set #{column} = #{column} + 1
    where user_id = ?"
    stmt = get_my.prepare(sql)
    stmt.execute user_id
  end
end