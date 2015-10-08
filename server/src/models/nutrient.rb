class Nutrient < Item
  ITEM_TYPE = 'nutrient'

  attr_reader :nutrient_type_id

  def initialize(id, nutrient_type_id, x, y)
    super(id, x, y)
    @nutrient_type_id = nutrient_type_id
  end

  def to_map
    {
        id: @id,
        item_type: ITEM_TYPE,
        x: @x,
        y: @y,
        nutrient_type_id: @nutrient_type_id,
        energy: @energy
    }
  end

  def self.from_map(item_map)
    new(item_map['id'], item_map['nutrient_type_id'].to_i,
        item_map['x'].to_i, item_map['y'].to_i)
  end
end