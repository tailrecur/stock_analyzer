RSpec::Matchers.define :have_value do |attribute, expected|
  @options = {}
  chain(:with) { |options| @options.merge!(options); options.each { |attr, value| subject.stub_method(attr => value) } }
  chain(:for) { |attr| @attr = attr }
  chain(:having_quarter_data) { |options| subject.stub_method(@attr => 4.times.collect { QuarterlyResult.stub_instance(options) }) }
  chain(:having_trend_data) { |attr, start| subject.stub_method(@attr => (0..5).inject([]) { |array, n|
    array.tap { |array| array << ProfitAndLoss.stub_instance(attr => (start+(n*start)).tap { |cur| start = cur }) } }
  ) }

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
