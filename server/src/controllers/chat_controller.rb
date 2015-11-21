class ChatController < ControllerBase
  def initialize
    super
    autowired(ChatMessageService, UserScoreService)
  end

  def chat(msg_map, params)
    chat_msg = ChatMessage.from_map(msg_map)
    user_id = chat_msg.user_id
    user_name = chat_msg.user_name
    content = chat_msg.content
    map_id = @user_service.get_map_id user_id
    LogUtil.info "get_map_id: #{map_id}"
    broadcast_in_map map_id, chat_msg unless map_id.nil?
    @user_score_service.inc_chat_score user_id
    @chat_message_service.add_message user_id, user_name, map_id, content
    nil
  end
end