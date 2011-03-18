class Company < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :sector
  has_many :balance_sheets, :order => "period_ended asc"
  has_many :cash_flows
  has_many :cash_flows_for_dcf, :class_name => "CashFlow", :order => "period_ended desc", :limit => 5
  has_many :quarterly_results
  has_many :profit_and_losses
  has_many :profit_and_losses_for_growth, :class_name => "ProfitAndLoss", :order => "period_ended desc", :limit => 5

  has_one :profit_and_loss, :order => "period_ended desc"
  has_one :balance_sheet, :order => "period_ended desc"
  has_one :cash_flow, :order => "period_ended desc"

  delegate :eps, :sales, :ebitda, :depreciation, :other_income, :net_profit, :to => :trailing_year
  delegate :issued_shares, :to => :profit_and_loss
  delegate :operating_cash, :to => :cash_flow
  delegate :total_share_capital, :enterprise_value, :capital_employed, :debt_to_equity_ratio, :book_value, :total_common_equity, :debt_ratio, :to => :balance_sheet

  default_scope where(:active => true)

  def trailing_year
    TrailingYear.new(self)
  end

  memoize :trailing_year
  memoize :profit_and_loss
  memoize :profit_and_losses_for_growth
  memoize :cash_flows_for_dcf
  memoize :balance_sheet
  memoize :cash_flow

  def pe_ratio
    price.divide_by eps
  end

  def ebit
    ebitda - depreciation
  end

  def market_cap
    issued_shares * price / 10000000 #in crores
  end

  def operating_income
    ebit - other_income
  end

  def roe
    (net_profit - profit_and_loss.preference_dividend).divide_by total_common_equity
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

  def operating_cash_to_sales
    operating_cash.divide_by sales
  end

  def sales_growth_rate
    profit_and_losses_for_growth.collect(&:sales_turnover).reverse.cagr
  end

  def expense_growth_rate
    profit_and_losses_for_growth.collect(&:total_expenses).reverse.cagr
  end

  def profit_growth_rate
    profit_and_losses_for_growth.collect(&:pbt).reverse.cagr
  end

  def peg_ratio
    pe_ratio.divide_by(profit_growth_rate)
  end

  def <=> other
    self.score <=> other.score
  end
end
