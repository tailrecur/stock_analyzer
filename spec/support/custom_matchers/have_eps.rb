RSpec::Matchers.define :have_eps do |expected|
  chain(:for) { |number| @number = number }
  chain(:quarters) { @number.times { company.quarterly_results << Factory.build(:quarterly_result, :eps => 5) } }

  match do |actual|
    actual.eps == expected
  end

  description do
    "be #{expected} for #{@number} quarters with eps 5"
  end
end
