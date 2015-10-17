class UserScoreService
  def initialize
    autowired(UserScoreDao)
  end

  def ensure_exists(user_id)
    unless @user_score_dao.has_record? user_id
      @user_score_dao.create_record user_id
    end
  end

  def inc_food_score(user_id)
    inc_score user_id, 'food_score'
  end

  def inc_rubbish_score(user_id)
    inc_score user_id, 'rubbish_score'
  end

  def inc_large_rubbish_score(user_id)
    inc_score user_id, 'large_rubbish_score'
  end

  def inc_chat_score(user_id)
    inc_score user_id, 'chat_score'
  end

  def inc_nutrient_score(user_id)
    inc_score user_id, 'nutrient_score'
  end

  private

  def inc_score(user_id, column)
    ensure_exists user_id
    @user_score_dao.inc_score user_id, column
  end
end