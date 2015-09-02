require_relative '../test_help'
require 'minitest/autorun'

class DesTest < MiniTest::Test
  def test_des
    text = '"{"type":"init_sync_user_message","data":{"user_id":"369b041c-056d-40b1-ba6e-d3fb71a263e0","user_name":"6666"}}"'
    des = Des.new('ant')
    encrypted_data = des.encrypt text
    puts encrypted_data
    assert_equal text, des.decrypt(encrypted_data)
  end
end
