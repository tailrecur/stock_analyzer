class Array
  def average
    valid_values = compact
    valid_values.inject(0) { |sum, val| sum+val } / valid_values.length
  end
end