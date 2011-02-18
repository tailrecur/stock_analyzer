RSpec::Matchers.define :have_value do |attribute, expected|
  @options = {}
  chain(:with) { |options| @options.merge!(options); options.each { |attr, value| subject.send("#{attr}=", value) } }
  chain(:with_stub) { |options| options.each { |attr, value| subject.stub_method(attr => value) } }
  chain(:for) { |number| @number = number }
  chain(:quarters) { |opts={}|
    (0..(@number-1)).each { |value|
      company.quarterly_results << Factory.build(:quarterly_result, {:period_ended => Date.parse("Mar #{10+value}")}.merge(opts))
    }
    company.save!
  }


  match do |actual|
    actual.send(attribute) == expected
  end

  description do
    "be #{expected || "nil"} for #{attribute} when #{@options.inspect}"
  end

  failure_message_for_should do |actual|
    "expected #{attribute} to be #{expected || 'nil'} but was #{actual.send(attribute) || 'nil'}"
  end
end
