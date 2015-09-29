class Rubbish < Item
  ITEM_TYPE = 'rubbish'

  attr_reader :rubbish_type_id

  def initialize(id, rubbish_type_id, x, y)
    super(id, x, y)
    @rubbish_type_id = rubbish_type_id
  end

  def to_map
    {
        id: @id,
        item_type: ITEM_TYPE,
        x: @x,
        y: @y,
        rubbish_type_id: @rubbish_type_id
    }
  end

  def self.from_map(item_map)
    new(item_map['id'], item_map['rubbish_type_id'].to_i,
        item_map['x'].to_i, item_map['y'].to_i)
  end
end