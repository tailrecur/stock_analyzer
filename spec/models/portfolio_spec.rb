require 'spec_helper'

describe Portfolio do
  it {should have_many(:portfolio_stocks)}
end
