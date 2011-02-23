class Object
  def time
    start = Time.now
    output = yield
    finish = Time.now
    puts "Total time: #{finish-start} seconds\n"
    output
  end

  def debug
    self.tap {|s| pp s }
  end

  def divide_by other
    return nil if other.zero?
    return nil if (other.is_a?(Float) and other.nan?)
    return nil if (self < 0 or other < 0)
    self / other
  end
end