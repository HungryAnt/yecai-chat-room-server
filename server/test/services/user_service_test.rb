require_relative '../test_help'
require 'minitest/autorun'

class UserServiceTest < MiniTest::Test
  def setup
  end

  def teardown
  end

  def test_join
    user_service = UserService.new
    assert_equal(0, user_service.get_clients('map_1').size)
    user_service.join('user_1', 'Ant', 'map_1', 0)
    assert_equal(1, user_service.get_clients('map_1').size)
    user_service.quit('user_1', 'map_1')
    assert_equal(0, user_service.get_clients('map_1').size)
  end

  def test_join2
    user_service = UserService.new
    map_id = 'map'
    0.upto(9) do |i|
      user_service.join("user_#{i}", "name_#{i}",map_id , 0)
      assert_equal(i + 1, user_service.get_clients(map_id).size)
    end
  end

  def test_get_clients2
    user_service = UserService.new
    user_count_per_map = 5
    0.upto(9) do |i|
      map_id = "map_#{i}"
      0.upto(user_count_per_map - 1) do |j|
        user_id = "user_#{i}_#{j}"
        user_name = "name_#{i}_#{j}"
        user_service.join user_id, user_name, map_id, 0
      end
    end

    0.upto(9) do |i|
      map_id = "map_#{i}"
      assert_equal(user_count_per_map, user_service.get_clients(map_id).size)
    end
  end
end