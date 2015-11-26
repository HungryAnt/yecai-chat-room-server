require_relative 'dao_base'

class ChatMessageDao < DaoBase
  def add_message(user_id, user_name, map_id, content)
    execute do |conn|
      sql = 'insert into v1_chat_messages(user_id, user_name, map_id, content) values(?, ?, ?, ?)'
      stmt = conn.prepare(sql)
      stmt.execute user_id, user_name, map_id, content
    end
  end
end