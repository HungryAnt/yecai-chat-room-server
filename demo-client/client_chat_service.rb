class ClientChatService
  def initialize
    @mutex = Mutex.new
    @text_msgs = []
  end

  def chat(msg)

  end

  def add_text_msg(text_msg)
    @mutex.synchronize {
      @text_msgs << text_msg
    }
  end
end