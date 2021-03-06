class Array
  def average
    valid_values = cleaned
    valid_values.inject(0) { |sum, val| sum+val } / valid_values.length if valid_values.present?
  end

  def median
    valid_values = cleaned.sort
    length = valid_values.length
    if length % 2 == 0
      [valid_values[length/2 - 1], valid_values[length/2] ].average
    else
      valid_values[valid_values.length/2]
    end
  end

  def trend
    [].tap { |diffs| cleaned.each_cons(2) { |prev, cur| diffs << (cur - prev).divide_by(prev) } }.average * 100
  end

  def cagr
    ((last / first) ** (1.0 / (length - 1)) - 1) * 100 unless (first.zero? or first < 0 or last < 0)
  end

  def cleaned
    compact.reject { |num| num.respond_to?(:nan?) and num.nan? }
  end
end