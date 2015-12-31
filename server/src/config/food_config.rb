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

    food 38, 300 # ����
    food 41, 180 # ��ͷ
    # food 44, 180 # ƽ��ҹ��ƻ��
    # food 45, 120 # ˮ�������
    # food 46, 120 # ���ް԰���
    # food 47, 120 # ����
    # food 48, 120 # �ɿ�������Ȧ
  end

  init

  public

  def self::food_energy(food_type_id)
    @@foods[food_type_id]
  end
end