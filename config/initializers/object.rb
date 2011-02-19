class Object
  def time
    start = Time.now
    output = yield
    finish = Time.now
    puts "Total time: #{finish-start} seconds\n"
    output
  end

  def debug
    self.tap {|s| puts s }
  end
end