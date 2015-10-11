class UserExpService
  def initialize
    autowired(UserDataDao)
  end

  def inc_user_exp(user_id, exp)
    current_lv, current_exp = @user_data_dao.get_user_lv(user_id)
    exp_tool = ExpTool.new(current_lv, current_exp)
    exp_tool.inc_exp exp
    LogUtil.info "inc_exp_message user_id:#{user_id}, inc_exp:#{exp}" +
                     "current:#{current_lv},#{current_exp} " +
                     "new:#{exp_tool.lv},#{exp_tool.exp}"
    @user_data_dao.update_user_lv user_id, exp_tool.lv, exp_tool.exp
    [exp_tool.lv, exp_tool.exp]
  end
end