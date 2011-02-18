require 'spec_helper'

describe Company do
  let(:company) { Factory.build(:company) }
  subject { company }

  describe "eps" do
    it { should have_value(:eps, 40).for(4).quarters(:eps => 10) }
    it { should have_value(:eps, 40).for(6).quarters(:eps => 10) }
    it { should have_value(:eps, nil).for(3).quarters(:eps => 10) }
  end

  describe "pe_ratio" do
    it { should have_value(:pe_ratio, 2.5).with(:price => 50).with_stub(:eps => 20) }
    it { should have_value(:pe_ratio, nil).with(:price => nil).with_stub(:eps => 20) }
    it { should have_value(:pe_ratio, nil).with(:price => 50).with_stub(:eps => nil) }
    it { should have_value(:pe_ratio, nil).with(:price => nil).with_stub(:eps => nil) }
    it { should have_value(:pe_ratio, nil).with(:price => 0).with_stub(:eps => 0.0) }
  end

  describe "profit_and_loss" do
    it("should be the latest profit_and_loss account for company") {
      expected_profit_and_loss = Factory.build(:profit_and_loss, :period_ended => Date.parse('Dec 08'))
      company.profit_and_losses << expected_profit_and_loss
      company.profit_and_losses << Factory.build(:profit_and_loss, :period_ended => Date.parse('Dec 05'))
      company.save!
      Factory(:profit_and_loss, :period_ended => Date.parse('Dec 09'))

      company.profit_and_loss.should == expected_profit_and_loss
    }

    it("should return nil if no profit_and_loss data found") {
      company.profit_and_loss.should be_nil
    }
  end

  describe "market_cap" do
    it { should have_value(:market_cap, 800).with(:price => 40).with_stub(:profit_and_loss => Factory.build(:profit_and_loss, :issued_shares => 20)) }
    it { should have_value(:market_cap, nil).with(:price => 40).with_stub(:profit_and_loss => nil) }
    it { should have_value(:market_cap, nil).with(:price => nil).with_stub(:profit_and_loss => Factory.build(:profit_and_loss, :issued_shares => 20)) }
    it { should have_value(:market_cap, nil).with(:price => 40).with_stub(:profit_and_loss => Factory.build(:profit_and_loss, :issued_shares => nil)) }
  end

  describe "default_scope" do
    it("should retrieve only active companies by default") {
      2.times { Factory(:company, :active => true); Factory(:company, :active => false) }
      Company.all.length.should == 2
    }
  end

  describe "yearly_sales" do
    it { should have_value(:yearly_sales, 360).for(4).quarters(:sales_turnover => 90) }
    it { should have_value(:yearly_sales, 360).for(6).quarters(:sales_turnover => 90) }
    it { should have_value(:yearly_sales, nil).for(3).quarters(:sales_turnover => 90) }
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

  describe "ev_to_sales" do
    let(:balance_sheet) { Factory.build(:balance_sheet).tap {|b| b.stub_method(:enterprise_value => 100)} }
    before { company.stub_method(:balance_sheet => balance_sheet)}
    it { should have_value(:ev_to_sales, nil).with_stub(:yearly_sales => nil) }
    it {
      balance_sheet.stub_method(:enterprise_value => nil)
      should have_value(:ev_to_sales, nil).with_stub(:yearly_sales => 50)
    }
    it { should have_value(:ev_to_sales, nil).with_stub(:yearly_sales => 0.0) }
    it { should have_value(:ev_to_sales, 2).with_stub(:yearly_sales => 50) }
  end
end