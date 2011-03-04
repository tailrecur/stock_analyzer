require 'spec_helper'

describe DiscountedCashFlow do
  describe "free_cash_flow_average" do
    it("should calculate the average for last 5 years data") do
      (1..6).each { |n| subject.cash_flows << Factory.build(:cash_flow, :cash_from_operations => n*200, :cash_from_investment => n*-100) }
      should have_value(:free_cash_flow_average, 333.48).for_pl_trend_data(:equity_dividend, 30)
    end
  end
end