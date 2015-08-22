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
      puts "DbConnectionPool get_conn: #{e.message}"
      puts e.backtrace.inspect
      conn = mysql_connect
      @pool[num] = conn
    end
    conn
  end

  private
  def mysql_connect
    Mysql.connect(DatabaseConfig::HOST, 'root', 'ant', 'yecai', 3306)
  end
end