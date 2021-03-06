# coding: UTF-8

class SystemMessage
  attr_accessor :content

  def initialize(content)
    @content = content
  end

  def to_json(*a)
    {
        type: 'system_message',
        data: {content: @content}
    }.to_json(*a)
  end

  def self.from_map(map)
    new(map['data']['content'])
  end
end