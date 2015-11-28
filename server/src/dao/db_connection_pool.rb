class DbConnectionPool
  INIT_POOL_SIZE = 20

  def initialize
    @pool = []
    0.upto(INIT_POOL_SIZE - 1) do
      @pool << mysql_connect
    end
    @mutex = Mutex.new
    @actual_pool_size = INIT_POOL_SIZE
  end

  def execute
    return unless block_given?
    begin
      conn = get_conn
      test conn
      yield conn
      add_to_pool conn
    rescue Exception => e
      @mutex.synchronize {
        @actual_pool_size -= 1
      }
      conn.close
      LogUtil.error 'DbConnectionPool execute'
      LogUtil.error e.backtrace.inspect
      raise e
    end
    LogUtil.info "actual_pool_size: #{@actual_pool_size}"
  end

  private
  def mysql_connect
    Mysql.connect(DatabaseConfig::HOST, 'root', 'ant', 'yecai', 3306,
                  Mysql::OPT_CONNECT_TIMEOUT=>1000,
                  Mysql::OPT_READ_TIMEOUT=>1000,
                  Mysql::OPT_WRITE_TIMEOUT=>1000)
  end

  def get_conn
    Timeout.timeout(3) do
      while @actual_pool_size >= 30
        sleep 2
      end
    end

    @mutex.synchronize {
      if @pool.size > 0
        return @pool.pop
      else
        @actual_pool_size += 1
        return mysql_connect
      end
    }
  end

  def add_to_pool(conn)
    @mutex.synchronize {
      @pool.push conn
    }
  end

  def test(conn)
    begin
      conn.query('select 1')
    rescue Exception => e
      LogUtil.error 'reconnect'
      conn.close
      conn = mysql_connect
    end
    conn
  end
end