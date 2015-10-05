require 'socket'
require 'Set'

class Demo2Client
  def initialize

  end

  def run
    hostname = 'localhost'
    port = 2003
    map = {}
    socket_clients = Set.new

    0.upto(1000) do
      s = TCPSocket.open(hostname, port)
      map[s] = 1
      s.close
      map.delete s
      socket_clients.add s
    end
    puts map.size
    puts socket_clients.size
  end
end

Demo2Client.new.run
