require 'spec_helper'

describe TrailingYear do
  let(:company) { Factory.build(:company, :id => 2) }
  let(:trailing_year) { TrailingYear.new(company) }
  subject { trailing_year }

  describe "quarters" do
    it {
      QuarterlyResult.stub_method(:where => QuarterlyResult, :yearly_latest => "foo")
      trailing_year.quarters.should == "foo"
      QuarterlyResult.should have_received(:where).with(:company_id => 2)
      QuarterlyResult.should have_received(:yearly_latest).without_args
    }
  end

  it { should have_value(:eps, 40).with_stub(:quarters => 4.times.collect { QuarterlyResult.stub_instance(:eps => 10) }) }
  it { should have_value(:sales, 40).with_stub(:quarters => 4.times.collect { QuarterlyResult.stub_instance(:sales_turnover => 10) }) }
  it { should have_value(:ebitda, 40).with_stub(:quarters => 4.times.collect { QuarterlyResult.stub_instance(:operating_profit => 10) }) }
  it { should have_value(:depreciation, 40).with_stub(:quarters => 4.times.collect { QuarterlyResult.stub_instance(:depreciation => 10) }) }
  it { should have_value(:other_income, 40).with_stub(:quarters => 4.times.collect { QuarterlyResult.stub_instance(:other_income => 10) }) }
  it { should have_value(:net_profit, 40).with_stub(:quarters => 4.times.collect { QuarterlyResult.stub_instance(:net_profit => 10) }) }
end