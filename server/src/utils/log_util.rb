require 'logger'

class LogUtil
  @@logger_file = Logger.new('./log.log', 'daily') #按天生成
  @@logger_file.level = Logger::INFO

  @@logger_stdout = Logger.new(STDOUT)
  @@logger_stdout.level = Logger::INFO

  @@logger_stderr = Logger.new(STDERR)
  @@logger_stderr.level = Logger::INFO

  def self.info(progname = nil, &block)
    @@logger_file.info(progname, &block)
    @@logger_stdout.info(progname, &block)
  end

  def self.warn(progname = nil, &block)
    @@logger_file.warn(progname, &block)
    @@logger_stdout.warn(progname, &block)
  end

  def self.error(progname = nil, &block)
    @@logger_file.error(progname, &block)
    @@logger_stderr.error(progname, &block)
  end
end