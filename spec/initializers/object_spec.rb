require 'spec_helper'

describe Object do
  describe "divide_by" do
    it { 10.divide_by(0).should be_nil }
    it { 10.divide_by(0.0).should be_nil }
    it { 10.divide_by(0.0/0.0).should be_nil }
    it { 10.divide_by(-1.4).should be_nil }
    it { -2.3.divide_by(3.5).should be_nil }
    it { -2.3.divide_by(-3.5).should be_nil }
  end
end