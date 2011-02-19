require 'spec_helper'

describe Array do
  describe "average" do
    it { [1, 2, 3].average.should == 2 }
    it { [1, 2, 10].average.should == 4 }
    it { [1, 2, 10.0].average.should be_within(0.1).of(4.33) }
    it { [1, 2, 10.0, nil].average.should be_within(0.1).of(4.33) }
    it { [1, 2, 10.0, 0.0/0.0].average.should be_within(0.1).of(4.33) }
    it { [nil, nil].average.should be_nil }
    it { [nil, 0.0/0.0].average.should be_nil }
  end

  describe "trend" do
    it { [1, 2, 3].trend.should == 1 }
    it { [1, 3, 4, 8, 10].trend.should == 2 }
    it { [1.0, 3.0, 4.0, 8.0, 10.0].trend.should == 2.25 }
    it { [1.0, 3.0, nil, 8.0, 10.0].trend.should == 3 }
    it { [1.0, 3.0, 0.0/0.0, 8.0, 10.0].trend.should == 3 }
  end
end