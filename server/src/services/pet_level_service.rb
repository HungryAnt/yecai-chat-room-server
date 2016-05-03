require 'redis'

class PetLevelService
  def initialize
    @redis = Redis.new(:host => 'localhost', :port => 6379, :db => 1)
  end

  def clear_for_test
    @redis.flushall
  end

  def inc_exp(pet_id, exp_inc)
    # @redis.multi do |multi|
    #   multi.set(pet_id, exp_inc)
    # end
    @redis.incrby(to_key(pet_id), exp_inc)
  end

  def set_exp(pet_id, exp)
    @redis.set(to_key(pet_id), exp)
  end

  def get_exp(pet_id)
    exp = @redis.get(to_key(pet_id))
    exp.nil? ? 0 : exp.to_i
  end

  def to_key(pet_id)
    return "pet_#{pet_id}_exp"
  end
end