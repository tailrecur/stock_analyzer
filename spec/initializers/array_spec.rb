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

  describe "median" do
    it { [1, 2.0, 3].median.should == 2.0 }
    it { [1.0, 8.0, 3.0, 10.0, 4.0].median.should == 4.0 }
    it { [1.0, 8.0, 3.0, 10.0, nil, 4.0].median.should == 4.0 }
    it { [1.0, 8.0, 0.0/0.0, 3.0, 10.0, nil, 4.0].median.should == 4.0 }
    it { [11.0, 1.0, 8.0, 3.0, 10.0, 4.0].median.should == 6.0 }
    it { [11.0, 1.0, nil, 8.0, 3.0, 10.0, 4.0].median.should == 6.0 }
    it { [11.0, 150, 7.0, 1.0, 8.0, 3.0, 10.0, 4.0, 1, 3.0].median.should == 5.5 }
  end

  describe "trend" do
    it { [1, 2.0, 3].trend.should == 75 }
    it { [1.0, 3.0, 4.0, 8.0, 10.0].trend.should be_within(0.01).of(89.58) }
    it { [1.0, 3.0, nil, 8.0, 10.0].trend.should be_within(0.01).of(130.55) }
    it { [1.0, 3.0, 0.0/0.0, 8.0, 10.0].trend.should be_within(0.01).of(130.55) }
  end

  describe "cagr" do
    it { [1.0, 2.0, 3.0].cagr.should be_within(0.01).of(73.21) }
    it { [2.0, 3.0, 4.0, 8.0, 10.0].cagr.should be_within(0.01).of(49.53) }
    it { [1.0, 3.0, nil, 7.0, 8.0].cagr.should be_within(0.01).of(68.18) }
    it { [nil, 1.0, 3.0, 10.0, 8.0].cagr.should be_nil }
    it { [1.0, 3.0, 7.0, 8.0, nil].cagr.should be_nil }
    it { [0.0, 1.0, 3.0, 10.0, 8.0].cagr.should be_nil }
    it { [-0.74, -0.16, 0.10, 0.46, 3.99].cagr.should be_nil }
    it { [0.74, -0.16, 0.10, 0.46, -3.99].cagr.should be_nil }
  end
end
