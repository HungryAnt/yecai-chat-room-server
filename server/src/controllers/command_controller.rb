class CommandController
  def initialize
    autowired(CommandService)
  end

  def command(msg_map, params)
    cmd_msg = CommandMessage.from_map(msg_map)
    @command_service.process cmd_msg
    nil
  end
end