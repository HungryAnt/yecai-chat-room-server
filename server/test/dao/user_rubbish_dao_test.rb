require_relative '../test_help'
require 'minitest/autorun'

class UserRubbishDaoTest < MiniTest::Test

  USER_ID = 'test_user'

  def setup
    @user_rubbish_dao = UserRubbishDao.new
    @user_rubbish_dao.clear
  end

  def teardown
    @user_rubbish_dao.clear
  end

  def test_add_rubbish
    0.upto(11) do |i|
      assert !@user_rubbish_dao.has_rubbish?(USER_ID, i)
      @user_rubbish_dao.create_rubbish USER_ID, i
      @user_rubbish_dao.add_rubbish USER_ID, i
      assert @user_rubbish_dao.has_rubbish?(USER_ID, i)
    end
    assert_equal 12, @user_rubbish_dao.count
  end
end