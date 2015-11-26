require_relative 'dao_base'

class UserVehicleDao < DaoBase
  def clear
    execute do |conn|
      conn.query('delete from v1_user_vehicles')
    end
  end

  def count
    r = nil
    execute do |conn|
      r = conn.query('select count(*) from v1_user_vehicles').fetch
    end
    r[0].to_i
  end

  def get_vehicles(user_id)
    vehicles = []
    execute do |conn|
      conn.prepare('select vehicle from v1_user_vehicles where user_id = ?')
          .execute(user_id).each do |r|
        vehicles << r[0]
      end
    end
    vehicles
  end

  def add_vehicle(user_id, vehicle)
    execute do |conn|
      stmt = conn.prepare('insert into v1_user_vehicles (user_id, vehicle) values (?, ?)')
      stmt.execute user_id, vehicle
    end
  end

  # def xxx
  #   my = get_my
  #   stmt1 = my.prepare('select * from v1_user_vehicles where user_id = ? and vehicle = ?')
  #   stmt2 = my.prepare('select * from v1_user_vehicles where user_id = ?')
  #
  #   stmt2.execute 'xx'
  #   stmt1.execute 'xx', 'xx'
  # end
end