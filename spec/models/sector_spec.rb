require 'spec_helper'

describe Sector do
  let(:sector) { Factory.build(:sector) }
  subject { sector }
  it("should calculate pe ratio") {
    Factory.build(:company).tap {|company| company.stub_method(:pe_ratio => 10); sector.companies << company}
    Factory.build(:company).tap {|company| company.stub_method(:pe_ratio => 20); sector.companies << company}
    sector.pe_ratio.should == 15
  }
end
