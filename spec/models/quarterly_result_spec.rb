require 'spec_helper'

describe QuarterlyResult do
  it("should retrieve data for the latest 4 quarters") {
    (0..5).each { |value| Factory(:quarterly_result, :period_ended => Date.parse("Mar #{10+value}")) }

    latest = QuarterlyResult.yearly_latest
    latest.length.should == 4
    latest.first.period_ended.should == Date.parse('Mar 15')
    latest.second.period_ended.should == Date.parse('Mar 14')
    latest.third.period_ended.should == Date.parse('Mar 13')
    latest.fourth.period_ended.should == Date.parse('Mar 12')
  }

  it("should return empty if atleast 4 quarters are not found") {
    (0..2).each { |value| Factory(:quarterly_result, :period_ended => Date.parse("Mar #{10+value}")) }
    QuarterlyResult.yearly_latest.should be_nil
  }
end
