require_relative '../test_help'
require 'minitest/autorun'

class PetLevelServiceTestTest < MiniTest::Test
  def setup
    @pet_level_service = PetLevelService.new
    clear
  end

  def teardown
    clear
  end

  def clear
    @pet_level_service.clear_for_test
  end

  def test_set_and_get_exp
    pet_id = 'pet_id'
    assert_equal 0, @pet_level_service.get_exp(pet_id)

    @pet_level_service.set_exp(pet_id, 5000)
    assert_equal 5000, @pet_level_service.get_exp(pet_id)
  end

  def test_inc_exp
    pet_id = 'pet_id'
    assert_equal 0, @pet_level_service.get_exp(pet_id)
    @pet_level_service.inc_lv_exp(pet_id, 5000)
    assert_equal 5000, @pet_level_service.get_exp(pet_id)
    @pet_level_service.inc_lv_exp(pet_id, 5000)
    assert_equal 10000, @pet_level_service.get_exp(pet_id)

    # 经验达到最大值后，不再增加
    @pet_level_service.inc_lv_exp(pet_id, PetLevelService::MAX_EXP)
    assert_equal PetLevelService::MAX_EXP, @pet_level_service.get_exp(pet_id)
    @pet_level_service.inc_lv_exp(pet_id, 100)
    assert_equal PetLevelService::MAX_EXP, @pet_level_service.get_exp(pet_id)
  end

  def test_to_level
    assert_level(0, 1, 0)
    assert_level(100, 1, 100)
    assert_level(200, 2, 0)
    assert_level(400, 2, 200)
    assert_level(600, 3, 0)
    assert_level(1200, 4, 0)
    assert_level(2000, 5, 0)
    assert_level(2999, 5, 999)
    assert_level(3000, 6, 0)
    assert_level(3001, 6, 1)
    assert_level(38000, 20, 0)
  end

  private

  def assert_level(lv_total, expected_lv, expected_exp_in_lv)
    level = PetLevelService.to_level lv_total
    assert_equal expected_lv, level[:lv]
    assert_equal expected_exp_in_lv, level[:exp_in_lv]
    expected_max_exp_in_lv = expected_lv * PetLevelService::EXP_PER_LV
    assert_equal expected_max_exp_in_lv, level[:max_exp_in_lv]
  end
end
