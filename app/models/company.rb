class Company < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :sector

  has_many :balance_sheets
  has_many :quarterly_results
  has_many :profit_and_losses

  delegate :eps, :sales, :ebitda, :depreciation, :other_income, :net_profit, :to => :trailing_year
  delegate :issued_shares, :to => :profit_and_loss
  delegate :total_share_capital, :enterprise_value, :capital_employed, :yearly_sales, :to => :balance_sheet

  default_scope where(:active => true)

  def trailing_year
    TrailingYear.new(self)
  end

  memoize :trailing_year

  def profit_and_loss
    profit_and_losses.latest
  end

  memoize :profit_and_loss

  def balance_sheet
    balance_sheets.latest
  end

  memoize :balance_sheet

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
end
