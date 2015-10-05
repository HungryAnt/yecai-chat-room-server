
def fun
  begin
    begin
      raise RuntimeError
    rescue Exception => e
      puts 'inner rescue'
      return
    ensure
      puts 'inner ensure'
    end
  rescue Exception => e
    puts 'outer rescue'
    puts e.backtrace.inspect
  ensure
    puts 'outer ensure'
  end
end

fun