require 'set'

class BroadcastService
  def initialize
    autowired(UserService)
    @socket_clients = Set.new
    @mutex = Mutex.new
    @send_proc = nil
  end

  def init_send_proc(&send_proc)
    @send_proc = send_proc
  end

  def add(client)
    @mutex.synchronize {
      @socket_clients.add client
    }
  end

  def delete(client)
    @mutex.synchronize {
      @socket_clients.delete client
    }
  end

  def send_all(msg_text)
    @mutex.synchronize {
      send_to_clients(msg_text,  @socket_clients)
    }
  end

  def send(map_id, msg_text)
    @mutex.synchronize {
      clients = @user_service.get_clients(map_id)
      # puts "clients size: #{clients.size}"
      send_to_clients(msg_text, clients)
    }
  end

  private
  def send_to_clients(msg_text, clients)
    return if @send_proc.nil?
    clients.each do |client|
      @send_proc.call client, msg_text
    end
  end
end