require 'redis'

class PetLevelService
  EXP_PER_LV = 200

  def initialize
    @redis = Redis.new(:host => 'localhost', :port => 6379, :db => 1)
  end

  def clear_for_test
    @redis.flushall
  end

  # 返回更新后的经验值
  def inc_exp(pet_id, exp_inc)
    # @redis.multi do |multi|
    #   multi.set(pet_id, exp_inc)
    # end
    exp_total = @redis.incrby(to_key(pet_id), exp_inc)
    level = PetLevelService.to_level exp_total
    LogUtil.info "pet inc_exp pet_id:#{pet_id} level:#{level}"
    level
  end

  def set_exp(pet_id, exp)
    @redis.set(to_key(pet_id), exp)
  end

  def get_exp(pet_id)
    exp = @redis.get(to_key(pet_id))
    exp.nil? ? 0 : exp.to_i
  end

  def to_key(pet_id)
    "pet_#{pet_id}_exp"
  end

  # exp_per_lv * (lv - 1) * lv / 2 = exp_lv_base
  # exp_lv_base 稍小于 exp_total
  def self.to_level(exp_total)
    a = 1.0
    b = -1.0
    c = -2.0 * exp_total / EXP_PER_LV
    lv = ((-b + Math.sqrt(b * b - 4 * a * c)) / (2 * a)).to_i
    exp_lv_base = EXP_PER_LV * (lv - 1) * lv / 2
    exp_in_lv = exp_total - exp_lv_base
    max_exp_in_lv = EXP_PER_LV * lv
    {
        lv: lv,
        exp_in_lv: exp_in_lv,
        max_exp_in_lv: max_exp_in_lv
    }
  end
end