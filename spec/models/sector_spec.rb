require 'spec_helper'

describe Sector do
  let(:sector) { Factory.build(:sector) }
  subject { sector }
  it("should calculate pe ratio") {
    Factory.build(:company).tap {|company| company.stub_method(:pe_ratio => 10); sector.companies << company}
    Factory.build(:company).tap {|company| company.stub_method(:pe_ratio => 20); sector.companies << company}
    sector.pe_ratio.should == 15
  }

  it("should calculate ev_to_sales") {
    Factory.build(:company).tap {|company| company.stub_method(:ev_to_sales => 10); sector.companies << company}
    Factory.build(:company).tap {|company| company.stub_method(:ev_to_sales => 20); sector.companies << company}
    sector.ev_to_sales.should == 15
  }

  it("should calculate ev_to_ebitda") {
    Factory.build(:company).tap {|company| company.stub_method(:ev_to_ebitda => 10); sector.companies << company}
    Factory.build(:company).tap {|company| company.stub_method(:ev_to_ebitda => 20); sector.companies << company}
    sector.ev_to_ebitda.should == 15
  }

  it("should calculate roe") {
    Factory.build(:company).tap {|company| company.stub_method(:roe => 10); sector.companies << company}
    Factory.build(:company).tap {|company| company.stub_method(:roe => 20); sector.companies << company}
    sector.roe.should == 15
  }
end
