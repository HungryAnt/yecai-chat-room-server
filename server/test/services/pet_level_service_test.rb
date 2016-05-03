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
    @pet_level_service.inc_exp(pet_id, 5000)
    assert_equal 5000, @pet_level_service.get_exp(pet_id)
    @pet_level_service.inc_exp(pet_id, 5000)
    assert_equal 10000, @pet_level_service.get_exp(pet_id)
  end
end
