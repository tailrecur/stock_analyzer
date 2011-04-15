class PortfolioStock < ActiveRecord::Base
  belongs_to :portfolio
  belongs_to :company
  validates_presence_of :portfolio, :company

  has_many :purchases, :class_name => "StockTransaction", :conditions => {:transaction_type => StockTransaction::PURCHASE}
  has_many :sales, :class_name => "StockTransaction", :conditions => {:transaction_type => StockTransaction::SALE}

  delegate :name, :price, :to => :company

  def quantity
    purchases.collect(&:quantity).sum - sales.collect(&:quantity).sum
  end

  def cost_price
    purchases.collect(&:cost_price).average
  end

  def outstanding_investment
    cost_price * quantity
  end

  def unrealized_profit
    (price - cost_price) * quantity
  end

  def unrealized_profit_percentage
    (price - cost_price) / cost_price * 100
  end

  def sale_price
    sales.collect(&:transaction_price).average
  end

  def sold_investment
    cost_price * sales.collect(&:quantity).sum
  end

  def realized_profit
    (sale_price - cost_price) * sales.collect(&:quantity).sum
  end

  def realized_profit_percentage
    (sale_price - cost_price) / cost_price * 100
  end

  def total_investment
    sold_investment + outstanding_investment
  end

  def total_profit
    realized_profit + unrealized_profit
  end

  def total_profit_percentage
    total_profit / total_investment * 100
  end
end