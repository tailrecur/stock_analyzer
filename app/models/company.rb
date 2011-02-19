class Company < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :sector
  has_many :balance_sheets
  has_many :quarterly_results
  has_many :profit_and_losses

  delegate :eps, :sales, :ebitda, :depreciation, :other_income, :net_profit, :to => :trailing_year
  delegate :issued_shares, :to => :profit_and_loss
  delegate :total_share_capital, :enterprise_value, :capital_employed, :yearly_sales, :debt_to_equity, :book_value, :to => :balance_sheet

  default_scope where(:active => true)

  def trailing_year
    TrailingYear.new(self)
  end

  def profit_and_loss
    profit_and_losses.latest
  end

  def balance_sheet
    balance_sheets.latest
  end

  def ordered_quarters
    quarterly_results.order("period_ended ASC")
  end

  memoize :trailing_year
  memoize :profit_and_loss
  memoize :balance_sheet
  memoize :ordered_quarters

  def pe_ratio
    price / eps unless eps.zero?
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
    net_profit / total_share_capital unless total_share_capital.zero?
  end

  def roce
    operating_income / capital_employed unless capital_employed.zero?
  end

  def ev_to_sales
    enterprise_value / yearly_sales unless yearly_sales.zero?
  end

  def ev_to_ebitda
    enterprise_value / ebitda unless ebitda.zero?
  end

  def price_to_book_value
    price / book_value unless book_value.zero?
  end

  def sales_growth_rate
    ordered_quarters.collect(&:sales_turnover).trend
  end

  def expense_growth_rate
    ordered_quarters.collect(&:total_expenses).trend
  end
end
