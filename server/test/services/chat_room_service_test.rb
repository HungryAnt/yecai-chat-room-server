require_relative '../test_help'
require 'test/unit'
require 'models/text_message'
require 'models/query_message'
require 'services/chat_room_service'

class MyTest < Test::Unit::TestCase

  def setup
    @chat_room_service = ChatRoomService.new
  end

  def teardown
  end

  def test_process_message
    assert_nil(add_text_message('ant', 'hello world'))

    assert_equal([], query_messages(-1))
    assert_equal([], query_messages(1))

    response_text_messages = query_messages 0
    assert_equal(1, response_text_messages.size)

    response_text_message = response_text_messages[0]
    assert_equal('ant', response_text_message.sender)
    assert_equal('hello world', response_text_message.content)
  end

  def test_process_messages
    0.upto(9) do |i|
      add_text_message "ant#{i}", "hello#{i}"
    end

    response_text_messages = query_messages(0)
    assert_equal(10, response_text_messages.size)

    response_text_messages = query_messages(1)
    assert_equal(9, response_text_messages.size)

    response_text_messages = query_messages(9)
    assert_equal(1, response_text_messages.size)

    response_text_messages = query_messages(10)
    assert_equal(0, response_text_messages.size)
  end

  def add_text_message(sender, content)
    text_message = TextMessage.new sender, content
    @chat_room_service.process_message to_map(text_message)
  end

  def query_messages(version)
    query_message = QueryMessage.new version
    @chat_room_service.process_message(to_map(query_message))
  end

  def to_map(message)
    JSON.parse(message.to_json)
  end
end