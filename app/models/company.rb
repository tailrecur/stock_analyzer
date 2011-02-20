class Company < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :sector
  has_many :balance_sheets, :order => "period_ended asc"
  has_many :quarterly_results, :order => "period_ended asc"
  has_many :profit_and_losses, :order => "period_ended asc"

  has_one :profit_and_loss, :order => "period_ended desc"
  has_one :balance_sheet, :order => "period_ended desc"

  composed_of :trailing_year, :mapping => %w(self company)

  delegate :eps, :sales, :ebitda, :depreciation, :other_income, :net_profit, :to => :trailing_year
  delegate :issued_shares, :to => :profit_and_loss
  delegate :total_share_capital, :enterprise_value, :capital_employed, :yearly_sales, :debt_to_equity, :book_value, :to => :balance_sheet

  default_scope where(:active => true)

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
    enterprise_value.divide_by yearly_sales
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
end
