require_relative '../test_help'
require 'minitest/autorun'

class UserNutrientServiceTest < MiniTest::Test
  USER_ID = 'test_user'

  def setup
    @user_nutrient_service = UserNutrientService.new
    @user_nutrient_service.clear
  end

  def teardown
    @user_nutrient_service.clear
  end

  def test_add_rubbish
    @user_nutrient_service.add_nutrient USER_ID, 1
    @user_nutrient_service.add_nutrient USER_ID, 2
    @user_nutrient_service.add_nutrient USER_ID, 2
    @user_nutrient_service.add_nutrient USER_ID, 2
    nutrients = @user_nutrient_service.get_nutrients(USER_ID)
    assert_equal UserRubbishDao::RUBBISHES_COUNT, nutrients.length
    assert_equal 0, nutrients[0]
    assert_equal 1, nutrients[1]
    assert_equal 3, nutrients[2]
  end
end