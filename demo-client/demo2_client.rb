require 'socket'

class Demo2Client
  def initialize

  end

  def run
    hostname = 'localhost'
    port = 2003
    0.upto(1000) do
      TCPSocket.open(hostname, port)
    end
  end
end

Demo2Client.new.run
sleep 10