class DaoBase
  def initialize
    autowired(DbConnectionPool)
  end

  def execute(&action)
    @db_connection_pool.execute &action
  end
end