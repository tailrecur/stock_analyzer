require 'spec_helper'

describe Scorer do
  let(:formulae) { [Factory.build(:formula, :value => "company.price > 5"), Factory.build(:formula, :value => "company.day_high < 25")] }
  let(:scorer) { Scorer.new(formulae) }
  it("should calculate scores for given companies and formulae") {
    company = Factory.build(:company, :price => 10, :day_high => 20)
    scorer.calculate_for(company).should == 2
  }

  it("should handle formulae evaluating to false") {
    company = Factory.build(:company, :price => 4, :day_high => 26)
    scorer.calculate_for(company).should == 0
  }

  it("should handle formulae evaluating to nil") {
    company = Factory.build(:company)
    scorer.calculate_for(company).should == 0
  }

  it("should handle formulae with negative weights") {
    company = Factory.build(:company, :price => 10, :day_high => 20)
    formulae.first.weight = -1
    scorer.calculate_for(company).should == 0
  }
end

