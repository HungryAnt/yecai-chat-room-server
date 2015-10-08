class DbConnectionPool
  POOL_SIZE = 10

  def initialize
    @pool = []
    0.upto(POOL_SIZE - 1) do
      @pool << mysql_connect
    end
  end

  def get_conn
    num = Thread.current.hash % POOL_SIZE
    conn = @pool[num]
    begin
      conn.query('select 1')
    rescue Exception => e
      LogUtil.error 'DbConnectionPool get_conn:'
      LogUtil.error e.backtrace.inspect
      conn = mysql_connect
      @pool[num] = conn
    end
    conn
  end

  private
  def mysql_connect
    Mysql.connect(DatabaseConfig::HOST, 'root', 'ant', 'yecai', 3306,
                  Mysql::OPT_CONNECT_TIMEOUT=>1000,
                  Mysql::OPT_READ_TIMEOUT=>1000,
                  Mysql::OPT_WRITE_TIMEOUT=>1000)
  end
end