require 'spec_helper'

describe Formula do
  it("should evaluate value field") {
    company = Factory.build(:company, :price => 10)
    formula = Factory.build(:formula, :value => "company.price > 0")
    formula.apply_to(company).should be_true
  }
end
