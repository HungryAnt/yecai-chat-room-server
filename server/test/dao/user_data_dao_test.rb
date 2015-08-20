require_relative '../test_help'
require 'minitest/autorun'

class UserDataDaoTest < MiniTest::Test

  USER_ID = 'test_user'
  USER_NAME = 'test_name'

  def setup
    @user_data_dao = UserDataDao.new
    @user_data_dao.clear
  end

  def teardown

  end

  def test_create_user
    @user_data_dao.create_user(USER_ID, USER_NAME)
  end

  def test_has_user
    assert !@user_data_dao.has_user?(USER_ID)
    @user_data_dao.create_user(USER_ID, USER_NAME)
    assert @user_data_dao.has_user?(USER_ID)
  end

  def test_sync_user_with_no_user
    assert !@user_data_dao.has_user?(USER_ID)
    @user_data_dao.sync_user(USER_ID, USER_NAME)
    assert @user_data_dao.has_user?(USER_ID)
  end

  def test_sync_user_with_user_exists
    @user_data_dao.sync_user(USER_ID, 'name1')
    @user_data_dao.sync_user(USER_ID, 'name2')
  end

  def test_update_user_lv
    @user_data_dao.sync_user(USER_ID, USER_NAME)
    @user_data_dao.update_user_lv USER_ID, 10, 999
    lv, exp = @user_data_dao.get_user_lv USER_ID
    assert_equal 10, lv
    assert_equal 999, exp
  end
end