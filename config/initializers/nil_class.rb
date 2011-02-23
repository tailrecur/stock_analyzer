class NilClass
  def method_missing(method, *args)
    nil
  end

  def to_str
    "nil"
  end

  def coerce foo
    [nil, nil]
  end
end