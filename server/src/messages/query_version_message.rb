class QueryVersionMessage
  def type
    'query_message'
  end

  def to_json(*a)
    {
        type: type,
        data: {version: @version}
    }.to_json(*a)
  end

  def self.json_create(map)
    new(map['data']['version'])
  end
end