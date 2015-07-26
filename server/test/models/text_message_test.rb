require_relative '../test_help'
require 'test/unit'
require 'models/text_message'

class MyTest < Test::Unit::TestCase
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
    message = TextMessage.new('ant', 'hello world')
    json_str = message.to_json
    assert_equal('{"type":"message","data":{"sender":"ant","content":"hello world"}}', json_str)

    message2 = TextMessage.json_create(JSON.parse(json_str))
    assert_equal('ant', message2.sender)
    assert_equal('hello world', message2.content)
  end
end