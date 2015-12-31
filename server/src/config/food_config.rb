class FoodConfig
  FOOD_TYPE_COUNT = 42

  @@foods = {}

  private

  def self::food(id, enegy)
    @@foods[id] = enegy
  end

  def self::init
    0.upto(FOOD_TYPE_COUNT-1) do |id|
      food(id, 50)
    end

    food 38, 300 # 辣条
    food 41, 180 # 骨头
    # food 44, 180 # 平安夜大苹果
    # food 45, 120 # 水果冰淇淋
    # food 46, 120 # 巨无霸安保
    # food 47, 120 # 拉面
    # food 48, 120 # 巧克力甜甜圈
  end

  init

  public

  def self::food_energy(food_type_id)
    @@foods[food_type_id]
  end
end