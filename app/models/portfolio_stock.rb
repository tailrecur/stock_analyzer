class PortfolioStock < ActiveRecord::Base
  belongs_to :portfolio
  belongs_to :company
  validates_presence_of :portfolio, :company

  has_many :purchases, :class_name => "StockTransaction", :conditions => {:transaction_type => StockTransaction::PURCHASE }
  has_many :sales, :class_name => "StockTransaction", :conditions => {:transaction_type => StockTransaction::SALE }

  delegate :name, :price, :to => :company

  def quantity
    purchases.collect(&:quantity).sum - sales.collect(&:quantity).sum
  end

  def cost_price
    purchases.collect(&:transaction_price).average
  end

  def sale_price
    sales.collect(&:transaction_price).average
  end

  def unrealized_profit
    (price - cost_price) * quantity
  end

  def unrealized_profit_percentage
    (price - cost_price) / cost_price * 100
  end

  def realized_profit
    (sale_price - cost_price) * sales.collect(&:quantity).sum
  end

  def realized_profit_percentage
    (sale_price - cost_price) / cost_price * 100
  end
end