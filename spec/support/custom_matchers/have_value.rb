RSpec::Matchers.define :have_value do |attribute, expected|
  @options = {}
  chain(:with) { |options| @options.merge!(options); options.each { |attr, value| company.send("#{attr}=", value) } }
  chain(:with_stub) { |options| options.each { |attr, value| company.stub_method(attr => value) } }

  match do |actual|
    actual.send(attribute) == expected
  end

  description do
    "be #{expected || "nil"} for #{attribute} when #{@options.inspect}"
  end

  failure_message_for_should do |actual|
    "expected #{attribute} to be #{expected || 'nil'} but was #{actual.send(attribute)}"
  end
end
