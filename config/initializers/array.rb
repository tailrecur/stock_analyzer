class Array
  def average
    valid_values = cleaned
    valid_values.inject(0) { |sum, val| sum+val } / valid_values.length if valid_values.present?
  end

  def trend
    [].tap {|diffs| cleaned.each_cons(2) { |prev, cur| diffs << (cur - prev) } }.average
  end

  def cleaned
    compact.reject { |num| num.respond_to?(:nan?) and num.nan? }
  end
end