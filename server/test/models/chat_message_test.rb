require_relative '../test_help'
require 'minitest/autorun'
require 'messages/chat_message'

class ChatMessageTest < MiniTest::Test
  def setup
  end

  def teardown
  end

  def test_json
    m = {}
    m[:a] = 110
    assert_equal('{"a":110}', m.to_json)
  end

  def test_message_json
    chat_msg1 = ChatMessage.new('user_id', 'ant', 'hello world')
    json_str = chat_msg1.to_json
    assert_equal('{"type":"chat_message","data":{"user_id":"user_id","user_name":"ant","content":"hello world"}}', json_str)

    chat_msg2 = ChatMessage.from_map(JSON.parse(json_str))
    assert_equal('user_id', chat_msg2.user_id)
    assert_equal('ant', chat_msg2.user_name)
    assert_equal('hello world', chat_msg2.content)
  end
end