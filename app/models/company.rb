class Company < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :sector
  has_many :balance_sheets, :order => "period_ended asc"
  has_many :quarterly_results, :order => "period_ended asc"
  has_many :profit_and_losses, :order => "period_ended asc"

  has_one :profit_and_loss, :order => "period_ended desc"
  has_one :balance_sheet, :order => "period_ended desc"

  delegate :eps, :sales, :ebitda, :depreciation, :other_income, :net_profit, :to => :trailing_year
  delegate :issued_shares, :to => :profit_and_loss
  delegate :total_share_capital, :enterprise_value, :capital_employed, :debt_to_equity_ratio, :book_value, :to => :balance_sheet

  default_scope where(:active => true)

  def trailing_year
     TrailingYear.new(self)
  end

  memoize :trailing_year
  memoize :profit_and_loss
  memoize :profit_and_losses
  memoize :balance_sheet

  def pe_ratio
    price.divide_by eps
  end

  def ebit
    ebitda - depreciation
  end

  def market_cap
    issued_shares * price
  end

  def operating_income
    ebit - other_income
  end

  def roe
    net_profit.divide_by total_share_capital
  end

  def roce
    operating_income.divide_by capital_employed
  end

  def ev_to_sales
    enterprise_value.divide_by sales
  end

  def ev_to_ebitda
    enterprise_value.divide_by ebitda
  end

  def price_to_book_value
    price.divide_by book_value
  end

  def sales_growth_rate
    profit_and_losses.collect(&:sales_turnover).trend
  end

  def expense_growth_rate
    profit_and_losses.collect(&:total_expenses).trend
  end

  def profit_growth_rate
    profit_and_losses.collect(&:pbt).trend
  end

  def eps_growth_rate
    profit_and_losses.collect(&:eps).trend
  end

  def peg_ratio
    pe_ratio.divide_by(eps_growth_rate)
  end

  def <=> other
    self.score <=> other.score
  end
end
