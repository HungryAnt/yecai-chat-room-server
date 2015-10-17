require_relative 'dao_base'

class UserVehicleDao < DaoBase
  def clear
    get_my.query('delete from v1_user_vehicles')
  end

  def count
    r = get_my.query('select count(*) from v1_user_vehicles').fetch
    r[0].to_i
  end

  def get_vehicles(user_id)
    vehicles = []
    get_my.prepare('select vehicle from v1_user_vehicles where user_id = ?')
        .execute(user_id).each do |r|
      vehicles << r[0]
    end
    vehicles
  end

  def add_vehicle(user_id, vehicle)
    stmt = get_my.prepare('insert into v1_user_vehicles (user_id, vehicle) values (?, ?)')
    stmt.execute user_id, vehicle
  end

  def xxx
    my = get_my
    stmt1 = my.prepare('select * from v1_user_vehicles where user_id = ? and vehicle = ?')
    stmt2 = my.prepare('select * from v1_user_vehicles where user_id = ?')

    stmt2.execute 'xx'
    stmt1.execute 'xx', 'xx'
  end
end