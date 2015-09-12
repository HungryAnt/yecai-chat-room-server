require_relative '../test_help'
require 'minitest/autorun'

class UserVehicleDaoTest < MiniTest::Test

  USER_ID = 'test_user'
  VEHICLE = 'vehicle_50'

  def setup
    @user_vehicle_dao = UserVehicleDao.new
    @user_vehicle_dao.clear
  end

  def teardown

  end

  def test_add_vehicle
    10.times {
      @user_vehicle_dao.add_vehicle(USER_ID, VEHICLE)
    }
    assert_equal 10, @user_vehicle_dao.count
  end

  def test_get_vehicles
    vehicles = @user_vehicle_dao.get_vehicles(USER_ID)
    assert_equal 0, vehicles.length

    @user_vehicle_dao.add_vehicle(USER_ID, VEHICLE)
    vehicles = @user_vehicle_dao.get_vehicles(USER_ID)
    assert_equal 1, vehicles.length

    @user_vehicle_dao.add_vehicle(USER_ID, VEHICLE)
    vehicles = @user_vehicle_dao.get_vehicles(USER_ID)
    assert_equal 2, vehicles.length
    assert_equal VEHICLE, vehicles[0]
    assert_equal VEHICLE, vehicles[1]
  end
end