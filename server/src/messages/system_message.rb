# coding: UTF-8

require_relative 'text_message'

class SystemMessage < TextMessage
  def initialize(content)
    super '系统', content
  end
end