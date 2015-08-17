class ItemFactory
  def self.create_item(item_map)
    case item_map['item_type']
      when 'food'
        return Food.from_map(item_map)
    end
  end
end