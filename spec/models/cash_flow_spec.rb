require 'spec_helper'

describe CashFlow do
  let(:cash_flow) { Factory.build(:cash_flow) }
  subject { cash_flow }

  it { should belong_to(:company) }
  
  describe "free_cash" do
    it { should have_value(:free_cash, nil).with(:cash_from_operations => nil, :cash_from_investment => -10.0) }
    it { should have_value(:free_cash, nil).with(:cash_from_operations => 10, :cash_from_investment => nil) }
    it { should have_value(:free_cash, 60).with(:cash_from_operations => 120.0, :cash_from_investment => -60.0) }
  end
end
