class StockTransaction < ActiveRecord::Base
  belongs_to :portfolio_stock

  validates_presence_of :transaction_type, :quantity, :transaction_price, :transaction_date, :exchange, :portfolio_stock
  validates_numericality_of(:quantity, :only_integer => true)
  validates_numericality_of(:transaction_price)

  validate :transaction_date_is_in_past

  PURCHASE = 'purchase'
  SALE = 'sale'

  before_save :calculate_cost_price

  def calculate_cost_price
    self.brokerage = 0 unless self.brokerage
    self.transaction_charges = 0 unless self.transaction_charges
    self.stamp_duty = 0 unless self.stamp_duty
    self.cost_price = ((transaction_price * quantity) + brokerage + transaction_charges + stamp_duty) / quantity
  end

  def transaction_date_is_in_past
    errors.add(:transaction_date, "should be in the past") if transaction_date > Date.today
  end

  scope :purchases, where(:transaction_type => PURCHASE)
  scope :sales, where(:transaction_type => SALE)
  scope :company, lambda { |company_id| joins(:portfolio_stock).where("portfolio_stocks.company_id = ?", company_id) }
end
