class Food
  attr_reader :id, :time_in_s

  def initialize(id, food_type_id, x, y, energy)
    @id, @food_type_id = id, food_type_id
    @x, @y = x, y
    @energy = energy
    @time_in_s = Time.now.to_i
  end

  def to_map
    {
        id: @id,
        item_type: 'food',
        x: @x,
        y: @y,
        food_type_id: @food_type_id,
        energy: @energy
    }
  end

  def to_id_map
    {
        id: @id
    }
  end

  def self.from_map(item_map)
    new(item_map['id'], item_map['food_type_id'].to_i,
        item_map['x'].to_i, item_map['y, energy'].to_i,
        item_map['energy'].to_f)
  end
end