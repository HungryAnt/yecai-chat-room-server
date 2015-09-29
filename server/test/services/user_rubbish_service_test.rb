require_relative '../test_help'
require 'minitest/autorun'

class UserRubbishServiceTest < MiniTest::Test
  USER_ID = 'test_user'

  def setup
    @user_rubbish_service = UserRubbishService.new
    @user_rubbish_service.clear
  end

  def teardown
    @user_rubbish_service.clear
  end

  def test_add_rubbish
    @user_rubbish_service.add_rubbish USER_ID, 1
    @user_rubbish_service.add_rubbish USER_ID, 1
    @user_rubbish_service.add_rubbish USER_ID, 5
    rubbishes = @user_rubbish_service.get_rubbishes(USER_ID)
    assert_equal UserRubbishDao::RUBBISHES_COUNT, rubbishes.length
    assert_equal 2, rubbishes[1]
    assert_equal 1, rubbishes[5]
    assert_equal 0, rubbishes[0]
    assert_equal 0, rubbishes[3]
  end
end