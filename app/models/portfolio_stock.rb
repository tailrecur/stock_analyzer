class PortfolioStock
  def initialize portfolio, company
    @portfolio = portfolio
    @company = company

    @purchases = StockTransaction.purchases.find_all_by_portfolio_id_and_company_id(portfolio.id, company.id)
    @sales = StockTransaction.sales.find_all_by_portfolio_id_and_company_id(portfolio.id, company.id)
  end
  attr_reader :portfolio, :company, :purchases, :sales

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