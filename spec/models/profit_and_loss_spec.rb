require 'spec_helper'

describe ProfitAndLoss do
  it("should be the latest profit_and_loss account") {
    expected_profit_and_loss = Factory(:profit_and_loss, :period_ended => Date.parse('Dec 08'))
    Factory(:profit_and_loss, :period_ended => Date.parse('Dec 05'))
    ProfitAndLoss.latest.should == expected_profit_and_loss
  }
end
