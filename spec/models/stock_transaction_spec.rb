require 'spec_helper'

describe StockTransaction do
  let(:stock_transaction) { Factory.build(:stock_transaction, :portfolio_stock => Factory.build(:portfolio_stock)) }
  subject { stock_transaction }

  it{ should belong_to(:portfolio_stock) }
  it{ should validate_presence_of(:transaction_type) }
  it{ should validate_presence_of(:quantity) }
  it{ should validate_presence_of(:transaction_price) }
  it{ should validate_presence_of(:transaction_date) }
  it{ should validate_presence_of(:exchange) }
  it{ should validate_presence_of(:portfolio_stock) }

  it{ should validate_numericality_of(:transaction_price) }
  it{ should validate_numericality_of(:quantity) }
  it{ should_not allow_value(13.1).for(:quantity) }

  it{ should_not allow_value(Date.today + 1).for(:transaction_date).with_message("should be in the past")}
  it{ should allow_value(Date.today).for(:transaction_date)}

  it "should calculate cost_price before save" do
    stock_transaction.transaction_price = 12.1
    stock_transaction.quantity = 20
    stock_transaction.brokerage = 14.3
    stock_transaction.transaction_charges = 4.3
    stock_transaction.stamp_duty = 3.2

    stock_transaction.save!
    stock_transaction.cost_price.should be_within(0.01).of(13.19)
  end
end
