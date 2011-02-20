require 'spec_helper'

describe TrailingYear do
  let(:company) { Factory.build(:company, :id => 2) }
  let(:trailing_year) { TrailingYear.new(company) }
  subject { trailing_year }

  describe "quarters" do
    it("should retrieve the latest 4 quarters") {
      QuarterlyResult.stub_method(:where => QuarterlyResult, :yearly_latest => "foo")
      trailing_year.quarters.should == "foo"
      QuarterlyResult.should have_received(:where).with(:company_id => 2)
      QuarterlyResult.should have_received(:yearly_latest).without_args
    }
  end

  it { should have_value(:eps, 40).for(:quarters).having_quarter_data(:eps => 10) }
  it { should have_value(:sales, 40).for(:quarters).having_quarter_data(:sales_turnover => 10) }
  it { should have_value(:ebitda, 40).for(:quarters).having_quarter_data(:operating_profit => 10) }
  it { should have_value(:depreciation, 40).for(:quarters).having_quarter_data(:depreciation => 10) }
  it { should have_value(:other_income, 40).for(:quarters).having_quarter_data(:other_income => 10) }
  it { should have_value(:net_profit, 40).for(:quarters).having_quarter_data(:net_profit => 10) }
end