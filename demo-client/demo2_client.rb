require 'socket'

class Demo2Client
  def initialize

  end

  def run
    hostname = 'localhost'
    port = 2003
    map = {}
    0.upto(1000) do
      s = TCPSocket.open(hostname, port)
      map[s] = 1
      s.close
      map.delete s
    end
    puts map.size
  end
end

Demo2Client.new.run
