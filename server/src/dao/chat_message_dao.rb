require_relative 'dao_base'

class ChatMessageDao < DaoBase
  def add_message(user_id, user_name, map_id, content)
    sql = 'insert into v1_chat_messages(user_id, user_name,
    map_id, content)
    values(?, ?, ?, ?)'
    stmt = get_my.prepare(sql)
    stmt.execute user_id, user_name, map_id, content
  end
end