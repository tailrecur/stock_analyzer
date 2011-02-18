class Array
  def average
    inject(0) { |sum, val| sum+val } / size
  end
end