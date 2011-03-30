class StockTransaction < ActiveRecord::Base
  belongs_to :company
  belongs_to :portfolio

  validates_presence_of :transaction_type, :quantity, :transaction_price, :transaction_date, :exchange, :company, :portfolio
  validates_numericality_of(:quantity, :only_integer => true)
  validates_numericality_of(:transaction_price)

  validate :transaction_date_is_in_past

  PURCHASE = 'purchase'
  SALE = 'sale'

  def transaction_date_is_in_past
    errors.add(:transaction_date, "should be in the past") if transaction_date > Date.today
  end

  scope :purchases, where(:transaction_type => PURCHASE)
  scope :sales, where(:transaction_type => SALE)
end
