class UserDataService
  def initialize
    autowired(UserDataDao)
  end

  # def get_user_lv(user_id)
  #   @user_data_dao.get_user_lv(user_id)
  # end

  def method_missing(method, *args)
    @user_data_dao.send(method, *args)
  end
end