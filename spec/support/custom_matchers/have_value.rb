RSpec::Matchers.define :have_value do |attribute, expected|
  @options = {}
  @related_options = {}
  chain(:with) { |options| @options.merge!(options); options.each { |attr, value| subject.stub_method(attr => value) } }
  chain(:for) { |attr| @attr = attr }
  chain(:having_quarter_data) { |options| @related_options = options; subject.stub_method(@attr => 4.times.collect { QuarterlyResult.stub_instance(options) }) }
  chain(:for_pl_trend_data) { |attr, start|
    (1..6).each { |n| subject.profit_and_losses << Factory.build(:profit_and_loss, attr => n*start) }
    subject.save!
  }

  match do |actual|
    if expected.nil?
      actual.send(attribute) == nil
    else
      (actual.send(attribute) - expected).abs < 0.01
    end
  end

  description do
    @messages = ["be #{expected || "nil"} for #{attribute}"]
    @messages << "#{@options.inspect}" if @options.present?
    @messages << "quarters having #{@related_options.inspect}" if @related_options.present?
    @messages.join(" and ")
  end

  failure_message_for_should do |actual|
    "expected #{attribute} to be #{expected || 'nil'} but was #{actual.send(attribute) || 'nil'}"
  end
end
