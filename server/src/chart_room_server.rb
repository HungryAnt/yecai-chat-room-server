# coding: UTF-8
$:.unshift(File.dirname(__FILE__))

require 'socket'
require 'json'
require 'messages/query_message'
require 'messages/text_message'
require 'messages/system_message'
require 'messages/join_message'
require 'messages/quit_message'
require 'services/chat_room_service'
require 'services/broadcast_service'
require 'services/user_service'


class ChartRoomServer
  def initialize
    map = {}

    Kernel.send :define_method, :get_instance do |clazz|
      instance = map[clazz]
      if instance.nil?
        instance = clazz.new
        map[clazz] = instance
      end
      instance
    end

    [ChatRoomService, BroadcastService, UserService].each do |clazz|
      get_instance(clazz)
    end
  end

  def init
    init_broadcast
    server = TCPServer.open(2000)
    loop {
      Thread.start(server.accept) do |client|
        broadcast_service = get_instance BroadcastService
        broadcast_service.add client
        begin
          accept client
        rescue Exception => e
          puts 'accept client raise exception:'
          puts e.message
          puts e.backtrace.inspect
        end
        broadcast_service.delete client
      end
    }
  end

  private

  def init_broadcast
    broadcast_service = get_instance(BroadcastService)
    broadcast_service.init_send_proc do |client, message|
      begin
        client.puts message
      rescue Exception => e
        puts 'broadcast send message raise exception:'
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end

  def accept(client)
    chat_room_service = get_instance(ChatRoomService)
    loop {
      while (line = client.readline)
        next if line.nil?
        line = line.chomp
        line.gsub! /\n|\r/, ''
        puts line
        begin
          result = chat_room_service.process line, client
          client.puts(result) unless result.nil?
        rescue Exception => e
          puts e.message
          puts e.backtrace.inspect
        end
      end
      # client.puts(Time.now.ctime) # 发送时间到客户端
      # client.puts "Closing the connection. Bye!"
      # client.close
    }
  end

end

server = ChartRoomServer.new
server.init