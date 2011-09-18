module PortfoliosHelper
  def outstanding_investment
    @portfolio.portfolio_stocks.map(&:outstanding_investment).compact.sum
  end

  def unrealized_profit
    @portfolio.portfolio_stocks.map(&:unrealized_profit).compact.sum
  end

  def unrealized_profit_percentage
    unrealized_profit.divide_by(outstanding_investment) * 100
  end

  def sold_investment
    @portfolio.portfolio_stocks.map(&:sold_investment).compact.sum
  end

  def realized_profit
    @portfolio.portfolio_stocks.map(&:realized_profit).compact.sum
  end

  def realized_profit_percentage
    realized_profit.divide_by(sold_investment) * 100
  end

  def total_investment
    @portfolio.portfolio_stocks.map(&:total_investment).compact.sum
  end

  def total_profit
    @portfolio.portfolio_stocks.map(&:total_profit).compact.sum
  end

  def total_profit_percentage
    total_profit.divide_by(total_investment) * 100
  end
end
