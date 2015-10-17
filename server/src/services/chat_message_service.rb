class ChatMessageService
  def initialize
    autowired(ChatMessageDao)
  end

  def add_message(user_id, user_name, map_id, content)
    @chat_message_dao.add_message user_id, user_name, map_id, content
  end
end