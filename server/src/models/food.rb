class Food
  attr_reader :time_in_s

  def initialize(id, food_type_id, x, y)
    @id, @food_type_id = id, food_type_id
    @x, @y = x, y
    @time_in_s = Time.now.to_i
  end

  def to_map
    {
        id: @id,
        item_type: 'food',
        x: @x,
        y: @y,
        food_type_id: @food_type_id
    }
  end
end