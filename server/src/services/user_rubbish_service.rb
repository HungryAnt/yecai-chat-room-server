class UserRubbishService
  def initialize
    autowired(UserRubbishDao)
  end

  def clear
    @user_rubbish_dao.clear
  end

  def add_rubbish(user_id, type_id)
    unless @user_rubbish_dao.has_rubbish?(user_id, type_id)
      @user_rubbish_dao.create_rubbish user_id, type_id
    end
    @user_rubbish_dao.add_rubbish user_id, type_id
  end

  def get_rubbishes(user_id)
    @user_rubbish_dao.get_rubbishes user_id
  end
end