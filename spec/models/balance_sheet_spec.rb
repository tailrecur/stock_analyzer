require 'spec_helper'

describe BalanceSheet do
  let(:balance_sheet) { Factory.build(:balance_sheet) }
  subject{ balance_sheet }
  
  it("should be the latest balance_sheet") {
    expected_balance_sheet = Factory(:balance_sheet, :period_ended => Date.parse('Dec 08'))
    Factory(:balance_sheet, :period_ended => Date.parse('Dec 05'))
    BalanceSheet.latest.should == expected_balance_sheet
  }

  describe "enterprise_value" do
    let(:company) { Factory.build(:company).tap {|c| c.stub_method(:market_cap => 60)} }
    it { should have_value(:enterprise_value, nil).with_stub(:company => nil) }
    it { should have_value(:enterprise_value, nil).with(:total_debt => 50).with_stub(:company => company) }
    it { should have_value(:enterprise_value, nil).with(:total_debt => 50, :cash_and_bank_balance => 30).with_stub(:company => company) }
    it { should have_value(:enterprise_value, 120).with(:total_debt => 50, :preference_share_capital => 40, :cash_and_bank_balance => 30)
                .with_stub(:company => company) }
  end
end
