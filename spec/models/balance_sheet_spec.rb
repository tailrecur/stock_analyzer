require 'spec_helper'

describe BalanceSheet do
  let(:balance_sheet) { Factory.build(:balance_sheet) }
  subject { balance_sheet }

  it { should belong_to(:company) }

  describe "enterprise_value" do
    let(:company) { Company.stub_instance(:market_cap => 60) }
    it { should have_value(:enterprise_value, nil, :company => nil) }
    it { should have_value(:enterprise_value, nil).with(:total_debt => 50, :company => company) }
    it { should have_value(:enterprise_value, nil).with(:total_debt => 50, :cash_and_bank_balance => 30, :company => company) }
    it { should have_value(:enterprise_value, 120).with(:total_debt => 50, :preference_share_capital => 40, :cash_and_bank_balance => 30, :company => company) }
  end

  describe "debt_to_equity" do
    it { should have_value(:debt_to_equity, nil).with(:total_debt => nil, :total_share_capital => 10) }
    it { should have_value(:debt_to_equity, nil).with(:total_debt => 10, :total_share_capital => nil) }
    it { should have_value(:debt_to_equity, nil).with(:total_debt => 10, :total_share_capital => 0.0) }
    it { should have_value(:debt_to_equity, 5).with(:total_debt => 60, :total_share_capital => 12.0) }
  end
end
