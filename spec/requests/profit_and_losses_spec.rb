require 'spec_helper'

describe "ProfitAndLosses" do
  describe "GET /profit_and_losses" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get profit_and_losses_path
      response.status.should be(200)
    end
  end
end
