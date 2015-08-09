$:.unshift(File.join(File.dirname(__FILE__), '..', 'src'))

require 'socket'
require 'json'
require 'engine/dependency_injection'
require 'messages/query_message'
require 'messages/text_message'
require 'messages/chat_message'
require 'messages/system_message'
require 'messages/join_message'
require 'messages/quit_message'
require 'models/user'
require 'services/message_handler_service'
require 'services/chat_room_service'
require 'services/broadcast_service'
require 'services/user_service'