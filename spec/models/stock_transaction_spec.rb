require 'spec_helper'

describe StockTransaction do
  let(:stock_transaction) { Factory.build(:stock_transaction, :company => Factory.build(:company)) }
  subject { stock_transaction }

  it{ should belong_to(:company) }
  it{ should validate_presence_of(:transaction_type) }
  it{ should validate_presence_of(:quantity) }
  it{ should validate_presence_of(:transaction_price) }
  it{ should validate_presence_of(:transaction_date) }
  it{ should validate_presence_of(:exchange) }
  it{ should validate_presence_of(:company) }

  it{ should validate_numericality_of(:transaction_price) }
  it{ should validate_numericality_of(:quantity) }
  it{ should_not allow_value(13.1).for(:quantity) }

  it{ should_not allow_value(Date.today + 1).for(:transaction_date).with_message("should be in the past")}
  it{ should allow_value(Date.today).for(:transaction_date)}
end
