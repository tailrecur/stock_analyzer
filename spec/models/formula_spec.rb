require 'spec_helper'

describe Formula do
  it("should evaluate value field") {
    company = Factory.build(:company, :price => 10)
    formula = Factory.build(:formula, :value => "company.price > 0")
    formula.apply_to(company).should be_true
  }

  describe "illustrate_for" do
    it("should handle simple comparisons") {
      company = Factory.build(:company, :price => 10.1)
      formula = Factory.build(:formula, :value => "company.price > 0")
      formula.illustrate_for(company).should == "10.1 > 0"
    }

    it("should handle complex comparisons") {
      company = Factory.build(:company, :price => 10.2, :day_high => 12.4)
      formula = Factory.build(:formula, :value => "company.price <= 0.67 * company.day_high")
      formula.illustrate_for(company).should == "10.2 <= 0.67 * 12.4"
    }

    it("should show nil values") {
      company = Factory.build(:company)
      formula = Factory.build(:formula, :value => "company.price > 0")
      formula.illustrate_for(company).should == "nil > 0"
    }

    it("should show format float values") {
      company = Factory.build(:company, :price => 3.923428344)
      formula = Factory.build(:formula, :value => "company.price > 0")
      formula.illustrate_for(company).should == "3.92 > 0"
    }

    it("should handle brackets") {
      company = Company.stub_instance(:profit_growth_rate => 10.3, :pe_ratio => 3.2, :sector => nil)
      formula = Factory.build(:formula, :value => "(company.profit_growth_rate / company.pe_ratio) > 2")
      formula.illustrate_for(company).should == "(10.3 / 3.2) > 2"
    }
  end
end
