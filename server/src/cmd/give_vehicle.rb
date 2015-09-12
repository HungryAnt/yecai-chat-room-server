require 'mysql'
require 'json'
require_relative '../engine/dependency_injection'
require_relative '../config/database_config'

require_relative '../dao/db_connection_pool'
require_relative '../dao/user_data_dao'
require_relative '../dao/user_vehicle_dao'

def give_vehicle
  all_vehicles = []
  [39, 40, 50, 58, 59, 67, 74, 75, 81, 82, 83, 89, 90, 91].each do |num|
    all_vehicles << "vehicle_#{num}"
  end

  user_data_dao = UserDataDao.new
  user_ids = user_data_dao.get_users_where_lv_greater_than 25

  user_ids.each do |user_id|
    vehicle = all_vehicles[rand(all_vehicles.length)]
    sql = "insert into v1_user_vehicles(user_id, vehicle) values('#{user_id}', '#{vehicle}')"
    puts sql
  end
end

give_vehicle
