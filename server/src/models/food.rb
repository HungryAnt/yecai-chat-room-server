class Food < Item
  ITEM_TYPE = 'food'

  def initialize(id, food_type_id, x, y, energy)
    super(id, x, y)
    @food_type_id = food_type_id
    @energy = energy
  end

  def to_map
    {
        id: @id,
        item_type: ITEM_TYPE,
        x: @x,
        y: @y,
        food_type_id: @food_type_id,
        energy: @energy
    }
  end

  def self.from_map(item_map)
    new(item_map['id'], item_map['food_type_id'].to_i,
        item_map['x'].to_i, item_map['y'].to_i,
        item_map['energy'].to_f)
  end
end