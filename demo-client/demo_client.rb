require 'socket'
require 'securerandom'
require_relative '../server/src/engine/dependency_injection'
require_relative '../server/src/services/message_handler_service'
require_relative '../server/src/messages/query_message'
require_relative '../server/src/messages/text_message'
require_relative '../server/src/messages/join_message'
require_relative '../server/src/messages/quit_message'

class DemoClient
  def initialize
    autowired(MessageHandlerService)
    hostname = 'localhost'
    port = 2000
    @s = TCPSocket.open(hostname, port)
    @current_version = 0
    @exit = false
  end

  def close
    @s.close
    puts 'close'
  end

  def run
    print 'input your name: '
    @user_id = SecureRandom.uuid
    @user_name = gets.chomp

    send_join_message

    # query_thread = Thread.new {
    #   loop {
    #     send_query_message
    #     sleep 1
    #     break if @exit
    #   }
    # }

    char_thread = Thread.new {
      loop {
        type_and_send_text_message
        break if @exit
      }
    }

    Thread.new {
      get_messages
    }

    char_thread.join
    query_thread.join

    send_quit_message

    close
  end

  def send_join_message
    @s.puts(JoinMessage.new(@user_id, @user_name).to_json)
  end

  def send_quit_message
    @s.puts(QuitMessage.new(@user_name).to_json)
  end

  def type_and_send_text_message
    content = gets.chomp
    return if content == ''
    if content == 'exit' || content == 'quit'
      @exit = true
      return
    end
    @s.puts(TextMessage.new(@user_name, content).to_json)
    puts 'send_text_message done!'
  end

  # def send_query_message
  #   # puts 'query_message'
  #   @s.puts(QueryMessage.new(@current_version).to_json)
  # end

  def get_messages
    init_message_handler
    begin
      while (line = @s.gets("\n"))
        next if line.nil?
        line = line.chomp.gsub /\n|\r/, ''
        next if line == ''
        msg_map = JSON.parse(line)
        @message_handler_service.process msg_map
      end
    rescue Exception => e
      puts 'get_messages raise exception:'
      puts e.backtrace.inspect
    end
  end

  private
  def init_message_handler
    register('text_message') do |msg_map, params|
      text_message = TextMessage.from_map(msg_map)
      puts "[#{text_message.sender}: #{text_message.content}]"
      if text_message.use_version?
        @current_version = text_message.version + 1
      end
    end
  end

  def register(msg_type, &handler)
    @message_handler_service.register msg_type, &handler
  end

end

DemoClient.new.run

