require 'set'

class BroadcastService
  def initialize
    @socket_clients = Set.new
    @mutex = Mutex.new
    @send_proc = nil
  end

  def init_send_proc(&send_proc)
    @send_proc = send_proc
  end

  def add(client)
    @socket_clients.add client
  end

  def delete(client)
    @socket_clients.delete client
  end

  def send(message)
    return if @send_proc.nil?
    @socket_clients.each do |client|
      @send_proc.call client, message
    end
  end
end