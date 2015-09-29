# class AccountDao
#   def initialize
#     autowired(DbConnectionPool)
#   end
#
#   def get_my
#     @db_connection_pool.get_conn
#   end
#
#   def clear
#     get_my.query('delete from v1_accounts')
#   end
#
#   def get_account
#     r = get_my.prepare('select amount from v1_accounts where user_id = ?').execute(user_id).fetch
#     r[0].to_i
#   end
# end