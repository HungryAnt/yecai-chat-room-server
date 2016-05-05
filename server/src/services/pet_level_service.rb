require 'redis'

class PetLevelService
  EXP_PER_LV = 200
  MAX_LV = 20

  def self.lv_max_exp(lv)
    EXP_PER_LV * (lv - 1) * lv / 2
  end

  MAX_EXP = lv_max_exp MAX_LV

  def initialize
    @redis = Redis.new(:host => 'localhost', :port => 6379, :db => 1)
  end

  def clear_for_test
    @redis.flushall
  end

  # 返回更新后的经验值
  def inc_lv_exp(pet_id, exp_inc)
    pre_exp_total = get_exp pet_id
    pre_exp_total.nil? ? pre_exp_total = 0 : pre_exp_total = pre_exp_total.to_i
    actual_exp_inc = [exp_inc, MAX_EXP - pre_exp_total].min
    exp_total = pre_exp_total + actual_exp_inc
    if actual_exp_inc > 0
      # exp_total = @redis.incrby(to_key(pet_id), actual_exp_inc)
      set_exp pet_id, exp_total
    end
    level = PetLevelService.to_level exp_total
    LogUtil.info "pet inc_exp pet_id:#{pet_id} level:#{level}"
    [level, actual_exp_inc]
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
    exp_lv_base = lv_max_exp lv
    exp_in_lv = exp_total - exp_lv_base
    max_exp_in_lv = EXP_PER_LV * lv
    {
        lv: lv,
        exp_in_lv: exp_in_lv,
        max_exp_in_lv: max_exp_in_lv
    }
  end
end