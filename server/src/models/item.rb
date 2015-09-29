class Item
  attr_reader :id, :time_in_s

  def initialize(id, x, y)
    @id, @x, @y= id, x, y
    @time_in_s = Time.now.to_i
  end

  def to_id_map
    {
        id: @id
    }
  end

end