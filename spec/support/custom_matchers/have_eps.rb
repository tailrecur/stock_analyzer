RSpec::Matchers.define :have_eps do |expected|
  chain(:for) { |number| @number = number }
  chain(:quarters) {
    (0..(@number-1)).each { |value|
      company.quarterly_results << Factory.build(:quarterly_result, :period_ended => Date.parse("Mar #{10+value}"), :eps => 10+(value*10))
    }
  }

  match do |actual|
    company.save!
    actual.eps == expected
  end

  description do
    "be #{expected} for #{@number} quarters with eps 5"
  end

  failure_message_for_should do |actual|
    "expected eps to be #{expected} but was #{actual.eps}"
  end
end
