require 'set'

class BroadcastService
  def initialize
    autowired(UserService, EncryptionService)
    @socket_clients = Set.new
    @mutex = Mutex.new
  end

  def add(client)
    LogUtil.info "BroadcastService add isLocked: #{@mutex.locked?}"
    @mutex.synchronize {
      LogUtil.info 'BroadcastService add'
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
      available_clients = clients.find_all {|client| @socket_clients.include? client}
      send_to_clients(msg_text, available_clients)
    }
  end

  private
  def send_to_clients(msg_text, clients)
    clients.each do |client|
      send_data client, msg_text
    end
  end

  def send_data(client, msg_text)
    begin
      LogUtil.info "begin send: #{msg_text}"
      @encryption_service.puts_data(client, msg_text)
      LogUtil.info "finish send: #{msg_text}"
    rescue Exception => e
      LogUtil.error "broadcast send message raise exception:"
      LogUtil.error e.backtrace.inspect
      @socket_clients.delete client
    end
  end
end