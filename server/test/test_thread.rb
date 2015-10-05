class TestThread
  i = 0
  loop {
    i += 1
    Thread.new() do {}
      puts "hello #{i}"
      sleep(100)
    end
    sleep(0.02)
  }
end