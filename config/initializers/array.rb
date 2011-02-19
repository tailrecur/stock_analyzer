class Array
  def average
    valid_values = compact.reject{|num| num.respond_to?(:nan?) and num.nan?}
    valid_values.inject(0) { |sum, val| sum+val } / valid_values.length if valid_values.present?
  end
end