require 'spec_helper'

describe Company do
  let(:company) { Factory.build(:company) }
  subject { company }

  describe "eps" do
    it { should have_eps(100).for(4).quarters }
    it { should have_eps(180).for(6).quarters }
    it { should have_eps(nil).for(3).quarters }
  end

  describe "pe_ratio" do
    it { should have_value(:pe_ratio, 2.5).with(:price => 50).with_stub(:eps => 20) }
    it { should have_value(:pe_ratio, nil).with(:price => nil).with_stub(:eps => 20) }
    it { should have_value(:pe_ratio, nil).with(:price => 50).with_stub(:eps => nil) }
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
end