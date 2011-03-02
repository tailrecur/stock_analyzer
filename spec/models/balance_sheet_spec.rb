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

  describe "debt_to_equity_ratio" do
    it { should have_value(:debt_to_equity_ratio, nil).with(:total_debt => nil, :preference_share_capital => 10, :total_share_capital => 10.0) }
    it { should have_value(:debt_to_equity_ratio, nil).with(:total_debt => 10, :preference_share_capital => 10, :total_share_capital => nil) }
    it { should have_value(:debt_to_equity_ratio, nil).with(:total_debt => 10, :preference_share_capital => nil, :total_share_capital => 10.0) }
    it { should have_value(:debt_to_equity_ratio, nil).with(:total_debt => 10, :preference_share_capital => 10, :total_share_capital => 0.0) }
    it { should have_value(:debt_to_equity_ratio, nil).with(:total_debt => 10, :preference_share_capital => 10, :total_share_capital => 0.0/0.0) }
    it { should have_value(:debt_to_equity_ratio, 20).with(:total_debt => 20, :preference_share_capital => 20, :total_share_capital => 200.0) }
  end

  describe "debt_ratio" do
    it { should have_value(:debt_ratio, nil).with(:total_debt => nil, :total_assets => 10) }
    it { should have_value(:debt_ratio, nil).with(:total_debt => nil, :total_assets => 10) }
    it { should have_value(:debt_ratio, nil).with(:total_debt => 10, :total_assets => 0.0/0.0, :contingent_liabilities => 0.0/0.0) }
    it { should have_value(:debt_ratio, 20).with(:total_debt => 20, :current_liabilities => 10, :provisions => 5, :total_assets => 200.0, :contingent_liabilities => 25) }
  end

  describe "debt_to_capital_ratio" do
    it { should have_value(:debt_to_capital_ratio, nil).with(:total_debt => nil, :total_share_capital => 10.0) }
    it { should have_value(:debt_to_capital_ratio, nil).with(:total_debt => 10, :total_share_capital => nil) }
    it { should have_value(:debt_to_capital_ratio, nil).with(:total_debt => 0.0, :total_share_capital => 0.0) }
    it { should have_value(:debt_to_capital_ratio, nil).with(:total_debt => 0.0, :total_share_capital => 0.0/0.0) }
    it { should have_value(:debt_to_capital_ratio, 25).with(:total_debt => 20.0, :total_share_capital => 60.0) }
  end

  describe "acid_test_ratio" do
    it { should have_value(:acid_test_ratio, nil).with(:total_current_assets => nil, :current_liabilities => 10) }
    it { should have_value(:acid_test_ratio, nil).with(:total_current_assets => 10, :current_liabilities => nil) }
    it { should have_value(:acid_test_ratio, nil).with(:total_current_assets => 10, :current_liabilities => 0.0) }
    it { should have_value(:acid_test_ratio, nil).with(:total_current_assets => 10, :current_liabilities => 0.0/0.0) }
    it { should have_value(:acid_test_ratio, 100).with(:total_current_assets => 250, :inventories => 150, :fixed_deposits => 20, :current_liabilities => 100, :provisions => 20) }
    it { should have_value(:acid_test_ratio, 75).with(:total_current_assets => 220.0, :inventories => 150, :fixed_deposits => 20, :current_liabilities => 100, :provisions => 20) }
  end

  describe "ncavps" do
    let(:company) { Company.stub_instance(:issued_shares => 20) }
    it { should have_value(:ncavps, nil).with(:net_current_assets => nil, :company => company) }
    it { should have_value(:ncavps, nil).with(:net_current_assets => 10, :company => nil) }
    it { should have_value(:ncavps, nil).with(:net_current_assets => 10, :company => company.tap { |c| c.stub_method(:issued_shares => 0.0) }) }
    it { should have_value(:ncavps, 5).with(:net_current_assets => 250, :total_debt => 100, :preference_share_capital => 50, :company => company) }
  end

  describe "net_cash" do
    it { should have_value(:net_cash, nil).with(:net_current_assets => nil, :total_debt => 10) }
    it { should have_value(:net_cash, nil).with(:net_current_assets => 10, :investments => nil) }
    it { should have_value(:net_cash, 15).with(:net_current_assets => 10, :investments => 20, :total_debt => 15) }
  end

  describe "total_equity" do
    it { should have_value(:total_equity, nil).with(:total_assets => nil, :total_debt => 10) }
    it { should have_value(:total_equity, nil).with(:total_assets => 10, :total_debt => nil) }
    it { should have_value(:total_equity, 20).with(:total_assets => 35, :total_debt => 15) }
  end
end
