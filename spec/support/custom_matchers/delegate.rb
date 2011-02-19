RSpec::Matchers.define :delegate do |method_name|
  chain(:to) { |to| @to = to }
#  chain(:via) { |to| @via = via }

  match do |klass|
    actual_object = klass.new
    delegate = actual_object.send(@to)
    delegate.stub_method(method_name => "foo")
    actual_object.send(method_name) == "foo"
  end

  failure_message_for_should { |klass| "expected #{klass.to_s} to delegate #{method_name} to #{@to}" }

  description { "delegate #{method_name} to #{@to}" }
end
