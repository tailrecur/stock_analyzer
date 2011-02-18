class Object
  def time
    start = Time.now
    output = yield
    finish = Time.now
    puts "Total time: #{finish-start} seconds\n"
    output
  end
end