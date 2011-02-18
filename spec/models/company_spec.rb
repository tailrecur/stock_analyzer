require 'spec_helper'

RSpec::Matchers.define :have_eps do |expected|
  chain(:for) { |number| @number = number }
  chain(:quarters) { @number.times { company.quarterly_results << Factory.build(:quarterly_result, :eps => 5) } }

  match do |actual|
    actual.eps == expected
  end

  description do
    "have be #{expected} for #{@number} quarters with eps 5"
  end
end

describe Company do
  describe "eps" do
    subject { company }
    let(:company) { Factory.build(:company) }

    it { should have_eps(20).for(4).quarters }
    it { should have_eps(20).for(6).quarters }
    it { should have_eps(-1).for(3).quarters }
  end
end
