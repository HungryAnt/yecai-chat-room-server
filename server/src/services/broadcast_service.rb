require 'set'
require 'timeout'

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
    LogUtil.info "BroadcastService delete isLocked: #{@mutex.locked?}"
    @mutex.synchronize {
      @socket_clients.delete client
    }
  end

  def send_all(msg_text)
    available_clients = nil
    @mutex.synchronize {
      available_clients = @socket_clients.to_a
    }
    send_to_clients(msg_text,  available_clients)
  end

  def send(map_id, msg_text)
    clients = @user_service.get_clients(map_id)
    available_clients = nil
    @mutex.synchronize {
      available_clients = clients.find_all {|client| @socket_clients.include? client}
    }
    send_to_clients(msg_text, available_clients)
  end

  private
  def send_to_clients(msg_text, clients)
    clients.each do |client|
      begin
        Timeout.timeout(1) do
          send_data client, msg_text
        end
      rescue Timeout::Error
        puts 'BroadcastService send_to_clients time out'
        delete client
      end
    end
  end

  def send_data(client, msg_text)
    begin
      @encryption_service.puts_data(client, msg_text)
    rescue Exception => e
      LogUtil.error "broadcast send message raise exception:"
      LogUtil.error e.backtrace.inspect
      delete client
    end
  end
end