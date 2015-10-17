class DaoBase
  def initialize
    autowired(DbConnectionPool)
  end

  def get_my
    @db_connection_pool.get_conn
  end
end