class MessageBase
  def to_map
    {
        type: 'none'
    }
  end

  def to_json(*a)
    to_map.to_json(*a)
  end

  def self.from_map(map)
    new(map['data']['user_name'])
  end
end