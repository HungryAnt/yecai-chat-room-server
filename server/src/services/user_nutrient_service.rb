class UserNutrientService
  def initialize
    autowired(UserNutrientDao)
  end

  def clear
    @user_nutrient_dao.clear
  end

  def add_nutrient(user_id, type_id)
    unless @user_nutrient_dao.has_nutrient?(user_id, type_id)
      @user_nutrient_dao.create_nutrient user_id, type_id
    end
    @user_nutrient_dao.add_nutrient user_id, type_id
  end

  def get_nutrients(user_id)
    @user_nutrient_dao.get_nutrients user_id
  end
end