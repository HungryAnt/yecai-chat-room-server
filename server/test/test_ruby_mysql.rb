require 'mysql'

my = Mysql.connect('127.0.0.1', 'root', 'ant', 'yecai', 3306)
stmt = my.prepare('insert into v1_users (user_id,user_name) values (?,?)')
stmt.execute '123', 'abc'

# my.query("select col1, col2 from tblname").each do |col1, col2|
#   p col1, col2
# end
# stmt = my.prepare('insert into tblname (col1,col2) values (?,?)')
# stmt.execute 123, 'abc'