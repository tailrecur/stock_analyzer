require 'spec_helper'

describe PortfolioStock do
  let(:company) { Factory(:company) }
  let(:portfolio) { Factory(:portfolio) }
  let(:portfolio_stock) { PortfolioStock.create!(:portfolio => portfolio, :company => company) }
  subject { portfolio_stock }

  it { should validate_presence_of(:portfolio) }
  it { should validate_presence_of(:company) }

  describe "delegations" do
    its(:name) { should == company.name }
    its(:price) { should == company.price }
  end

  describe "#quantity" do
    context "when there are only purchases" do
      before {
        Factory(:stock_purchase, :quantity => 5, :portfolio_stock => portfolio_stock)
        Factory(:stock_purchase, :quantity => 5, :portfolio_stock => portfolio_stock)
      }
      its(:quantity) { should == 10 }
    end

    context "when there are a mixture of purchases and sales" do
      before {
        Factory(:stock_purchase, :quantity => 5, :portfolio_stock => portfolio_stock)
        Factory(:stock_sale, :quantity => 3, :portfolio_stock => portfolio_stock)
      }
      its(:quantity) { should == 2 }
    end

    context "when purchases and sales are equal" do
      before {
        Factory(:stock_purchase, :quantity => 5, :portfolio_stock => portfolio_stock)
        Factory(:stock_sale, :quantity => 5, :portfolio_stock => portfolio_stock)
      }
      its(:quantity) { should == 0 }
    end
  end

  describe "#cost_price" do
    before {
      Factory(:stock_purchase, :transaction_price => 21.4, :portfolio_stock => portfolio_stock)
      Factory(:stock_purchase, :transaction_price => 31.4, :portfolio_stock => portfolio_stock)
    }
    its(:cost_price) { should == 26.4 }
  end

  describe "#sale_price" do
    before {
      Factory(:stock_sale, :transaction_price => 21.4, :portfolio_stock => portfolio_stock)
      Factory(:stock_sale, :transaction_price => 31.4, :portfolio_stock => portfolio_stock)
    }
    its(:sale_price) { should == 26.4 }
  end

  describe "#unrealized_profit" do
    before {
      Factory(:stock_purchase, :transaction_price => 26.4, :portfolio_stock => portfolio_stock, :quantity => 5)
      company.price = 44.2
    }
    its(:unrealized_profit) { should be_within(0.01).of(89) }
  end

  describe "#unrealized_profit_percentage" do
    before {
      Factory(:stock_purchase, :transaction_price => 26.4, :portfolio_stock => portfolio_stock, :quantity => 5)
      company.price = 44.2
    }
    its(:unrealized_profit_percentage) { should be_within(0.01).of(67.42) }
  end

  describe "#realized_profit" do
    context "when purchases and sales are equal" do
      before {
        Factory(:stock_purchase, :transaction_price => 21.4, :portfolio_stock => portfolio_stock, :quantity => 5)
        Factory(:stock_sale, :transaction_price => 31.4, :portfolio_stock => portfolio_stock, :quantity => 5)
      }
      its(:realized_profit) { should be_within(0.01).of(50) }
    end

    context "when sales are less than purchases" do
      before {
        Factory(:stock_purchase, :transaction_price => 21.4, :portfolio_stock => portfolio_stock, :quantity => 50)
        Factory(:stock_sale, :transaction_price => 31.4, :portfolio_stock => portfolio_stock, :quantity => 10)
        Factory(:stock_sale, :transaction_price => 35.4, :portfolio_stock => portfolio_stock, :quantity => 10)
      }
      its(:realized_profit) { should be_within(0.01).of(240) }
    end

    context "when profit is negative" do
      before {
        Factory(:stock_purchase, :transaction_price => 31.4, :portfolio_stock => portfolio_stock, :quantity => 10)
        Factory(:stock_sale, :transaction_price => 23.4, :portfolio_stock => portfolio_stock, :quantity => 5)
        Factory(:stock_sale, :transaction_price => 27.5, :portfolio_stock => portfolio_stock, :quantity => 5)
      }
      its(:realized_profit) { should be_within(0.01).of(-59.5) }
    end
  end

  describe "#realized_profit_percentage" do
    before {
      Factory(:stock_purchase, :transaction_price => 21.4, :portfolio_stock => portfolio_stock, :quantity => 5)
      Factory(:stock_purchase, :transaction_price => 27.9, :portfolio_stock => portfolio_stock, :quantity => 5)
      Factory(:stock_sale, :transaction_price => 33.4, :portfolio_stock => portfolio_stock, :quantity => 5)
      Factory(:stock_sale, :transaction_price => 36.5, :portfolio_stock => portfolio_stock, :quantity => 5)
      company.price = 44.2
    }
    its(:realized_profit_percentage) { should be_within(0.01).of(41.78) }
  end
end
