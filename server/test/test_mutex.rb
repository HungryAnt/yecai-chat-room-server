class TestMutex
  def initialize
    @mutex = Mutex.new
  end

  def run
    @mutex.synchronize {
      if @mutex.locked?
        puts 'ok'
      else
        @mutex.synchronize {
          puts 'ok'
        }
      end
    }
  end
end

TestMutex.new.run