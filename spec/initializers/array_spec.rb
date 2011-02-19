require 'spec_helper'

describe Array do
  it { [1, 2, 3].average.should == 2 }
  it { [1, 2, 10].average.should == 4 }
  it { [1, 2, 10.0].average.should be_within(0.1).of(4.33) }
  it { [1, 2, 10.0, nil].average.should be_within(0.1).of(4.33) }
  it { [1, 2, 10.0, 0.0/0.0].average.should be_within(0.1).of(4.33) }
  it { [nil, nil].average.should be_nil }
  it { [nil, 0.0/0.0].average.should be_nil }
end