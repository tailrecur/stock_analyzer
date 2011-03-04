require 'spec_helper'

describe Company do
  let(:company) { Factory.build(:company) }
  subject { company }

  describe "delegation" do
    subject { Company }
    it { should delegate(:eps).to(:trailing_year) }
    it { should delegate(:sales).to(:trailing_year) }
    it { should delegate(:ebitda).to(:trailing_year) }
    it { should delegate(:depreciation).to(:trailing_year) }
    it { should delegate(:other_income).to(:trailing_year) }
    it { should delegate(:net_profit).to(:trailing_year) }

    it { should delegate(:issued_shares).to(:profit_and_loss) }

    it { should delegate(:total_share_capital).to(:balance_sheet) }
    it { should delegate(:enterprise_value).to(:balance_sheet) }
    it { should delegate(:capital_employed).to(:balance_sheet) }
    it { should delegate(:debt_to_equity_ratio).to(:balance_sheet) }
    it { should delegate(:book_value).to(:balance_sheet) }
    it { should delegate(:total_common_equity).to(:balance_sheet) }

    it { should delegate(:operating_cash).to(:cash_flow) }
  end

  it("should instantiate trailing year correctly") {
    company.save!
    4.times { Factory(:quarterly_result, :eps => 10, :company_id => company.id) }
    company.trailing_year.eps.should == 40
  }

  describe "pe_ratio" do
    it { should have_value(:pe_ratio, nil).with(:price => nil, :eps => 20) }
    it { should have_value(:pe_ratio, nil).with(:price => 50, :eps => nil) }
    it { should have_value(:pe_ratio, nil).with(:price => nil, :eps => nil) }
    it { should have_value(:pe_ratio, nil).with(:price => 0, :eps => 0.0) }
    it { should have_value(:pe_ratio, 2.5).with(:price => 50.0, :eps => 20) }
  end

  describe "ebit" do
    it { should have_value(:ebit, nil).with(:ebitda => nil, :depreciation => 20) }
    it { should have_value(:ebit, nil).with(:ebitda => 100, :depreciation => nil) }
    it { should have_value(:ebit, 80).with(:ebitda => 100, :depreciation => 20) }
  end

  describe "market_cap" do
    it { should have_value(:market_cap, nil).with(:issued_shares => nil, :price => 40) }
    it { should have_value(:market_cap, nil).with(:issued_shares => 20, :price => nil) }
    it { should have_value(:market_cap, 28).with(:issued_shares => 200000, :price => 1400.0) }
  end

  describe "operating_income" do
    it { should have_value(:operating_income, nil).with(:ebit => nil, :other_income => 40) }
    it { should have_value(:operating_income, nil).with(:ebit => 400, :other_income => nil) }
    it { should have_value(:operating_income, 360).with(:ebit => 400, :other_income => 40) }
  end

  describe "roe" do
    let(:profit_and_loss) { Factory.build(:profit_and_loss, :preference_dividend => 10)}
    it { should have_value(:roe, nil).with(:net_profit => nil, :total_common_equity => 40, :profit_and_loss => profit_and_loss) }
    it { should have_value(:roe, nil).with(:net_profit => 120, :total_common_equity => nil, :profit_and_loss => profit_and_loss) }
    it { should have_value(:roe, nil).with(:net_profit => 120, :total_common_equity => 0.0, :profit_and_loss => profit_and_loss) }
    it { should have_value(:roe, 2.75).with(:net_profit => 120, :total_common_equity => 40, :profit_and_loss => profit_and_loss) }
  end

  describe "roce" do
    it { should have_value(:roce, nil).with(:operating_income => nil, :capital_employed => 40) }
    it { should have_value(:roce, nil).with(:operating_income => 120, :capital_employed => nil) }
    it { should have_value(:roce, nil).with(:operating_income => 120, :capital_employed => 0.0) }
    it { should have_value(:roce, 3).with(:operating_income => 120, :capital_employed => 40) }
  end

  describe "ev_to_sales" do
    it { should have_value(:ev_to_sales, nil).with(:enterprise_value => nil, :sales => 40) }
    it { should have_value(:ev_to_sales, nil).with(:enterprise_value => 120, :sales => nil) }
    it { should have_value(:ev_to_sales, nil).with(:enterprise_value => 120, :sales => 0.0) }
    it { should have_value(:ev_to_sales, 3).with(:enterprise_value => 120, :sales => 40) }
  end

  describe "ev_to_ebitda" do
    it { should have_value(:ev_to_ebitda, nil).with(:enterprise_value => nil, :ebitda => 40) }
    it { should have_value(:ev_to_ebitda, nil).with(:enterprise_value => 120, :ebitda => nil) }
    it { should have_value(:ev_to_ebitda, nil).with(:enterprise_value => 120, :ebitda => 0.0) }
    it { should have_value(:ev_to_ebitda, 3).with(:enterprise_value => 120, :ebitda => 40) }
  end

  describe "price_to_book_value" do
    it { should have_value(:price_to_book_value, nil).with(:price => nil, :book_value => 40) }
    it { should have_value(:price_to_book_value, nil).with(:price => 120, :book_value => nil) }
    it { should have_value(:price_to_book_value, nil).with(:price => 120, :book_value => 0.0) }
    it { should have_value(:price_to_book_value, 3).with(:price => 120, :book_value => 40) }
  end

  describe "operating_cash_flow_to_sales" do
    it { should have_value(:operating_cash_to_sales, nil).with(:operating_cash => nil, :sales => 40) }
    it { should have_value(:operating_cash_to_sales, nil).with(:operating_cash => 120, :sales => nil) }
    it { should have_value(:operating_cash_to_sales, nil).with(:operating_cash => 120, :sales => 0.0) }
    it { should have_value(:operating_cash_to_sales, 3).with(:operating_cash => 120, :sales => 40) }
  end

  describe "peg_ratio" do
    it { should have_value(:peg_ratio, nil).with(:pe_ratio => nil, :profit_growth_rate => 40) }
    it { should have_value(:peg_ratio, nil).with(:pe_ratio => 120, :profit_growth_rate => nil) }
    it { should have_value(:peg_ratio, nil).with(:pe_ratio => 120, :profit_growth_rate => 0.0) }
    it { should have_value(:peg_ratio, 3).with(:pe_ratio => 120, :profit_growth_rate => 40) }
  end

  describe "sales_growth_rate" do
    it { should have_value(:sales_growth_rate, nil).with(:profit_and_losses_for_growth => nil) }
    it { should have_value(:sales_growth_rate, nil).for_pl_trend_data(:sales_turnover,nil) }
    it { should have_value(:sales_growth_rate, 31.60).for_pl_trend_data(:sales_turnover,100) }
  end

  describe "expense_growth_rate" do
    it { should have_value(:expense_growth_rate, nil).with(:profit_and_losses_for_growth => nil) }
    it { should have_value(:expense_growth_rate, nil).for_pl_trend_data(:total_expenses,nil) }
    it { should have_value(:expense_growth_rate, 31.60).for_pl_trend_data(:total_expenses,100) }
  end

  describe "profit_growth_rate" do
    it { should have_value(:profit_growth_rate, nil).with(:profit_and_losses_for_growth => nil) }
    it { should have_value(:profit_growth_rate, nil).for_pl_trend_data(:pbt,nil) }
    it { should have_value(:profit_growth_rate, 31.6).for_pl_trend_data(:pbt,100) }
  end

  describe "profit_and_loss" do
    it("should be the latest profit_and_loss account for company") {
      expected_profit_and_loss = Factory.build(:profit_and_loss, :period_ended => Date.parse("Dec '08"))
      company.profit_and_losses << expected_profit_and_loss
      company.profit_and_losses << Factory.build(:profit_and_loss, :period_ended => Date.parse("Dec '05"))
      company.save!
      Factory(:profit_and_loss, :period_ended => Date.parse("Dec '09"))
      company.profit_and_loss.should == expected_profit_and_loss
    }

    it("should return nil if no profit_and_loss data found") {
      company.profit_and_loss.should be_nil
    }
  end

  describe "balance_sheet" do
    it("should be the latest balance_sheet for company") {
      expected_balance_sheet = Factory.build(:balance_sheet, :period_ended => Date.parse('Dec 08'))
      company.balance_sheets << expected_balance_sheet
      company.balance_sheets << Factory.build(:balance_sheet, :period_ended => Date.parse('Dec 05'))
      company.save!
      Factory(:balance_sheet, :period_ended => Date.parse('Dec 09'))

      company.balance_sheet.should == expected_balance_sheet
    }

    it("should return nil if no balance_sheet data found") {
      company.balance_sheet.should be_nil
    }
  end

  describe "cash_flow" do
    it("should be the latest cash_flow for company") {
      expected_cash_flow = Factory.build(:cash_flow, :period_ended => Date.parse('Dec 08'))
      company.cash_flows << expected_cash_flow
      company.cash_flows << Factory.build(:cash_flow, :period_ended => Date.parse('Dec 05'))
      company.save!
      Factory(:cash_flow, :period_ended => Date.parse('Dec 09'))

      company.cash_flow.should == expected_cash_flow
    }

    it("should return nil if no cash_flow data found") {
      company.cash_flow.should be_nil
    }
  end

  describe "default_scope" do
    it("should retrieve only active companies by default") {
      2.times { Factory(:company, :active => true); Factory(:company, :active => false) }
      Company.all.length.should == 2
    }
  end
end