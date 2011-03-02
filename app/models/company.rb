class Company < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :sector
  has_many :balance_sheets, :order => "period_ended asc"
  has_many :cash_flows
  has_many :cash_flows_for_dcf, :class_name => "CashFlow", :order => "period_ended desc", :limit => 5
  has_many :quarterly_results, :order => "period_ended asc"
  has_many :profit_and_losses
  has_many :profit_and_losses_for_growth, :class_name => "ProfitAndLoss", :order => "period_ended desc", :limit => 5

  has_one :profit_and_loss, :order => "period_ended desc"
  has_one :balance_sheet, :order => "period_ended desc"
  has_one :cash_flow, :order => "period_ended desc"

  delegate :eps, :sales, :ebitda, :depreciation, :other_income, :net_profit, :to => :trailing_year
  delegate :issued_shares, :to => :profit_and_loss
  delegate :operating_cash, :to => :cash_flow
  delegate :total_share_capital, :enterprise_value, :capital_employed, :debt_to_equity_ratio, :book_value, :total_equity, :debt_ratio, :to => :balance_sheet

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
    issued_shares * price
  end

  def operating_income
    ebit - other_income
  end

  def fcf_average
#    fcfs = []
#    cash_flows_for_dcf.each_with_index { |cash_flow, index| fcfs << (cash_flow.free_cash - profit_and_losses_for_growth[index].equity_dividend) }
#    fcfs.average * ((1.06) ** 3) #Assuming 6% average inflation for India
    profit_and_loss.net_profit + balance_sheet.accumulated_depreciation + cash_flow.cash_from_investment - balance_sheet.total_debt
  end

  def discount_rate
    0.1
  end

  def fcfs
    future_fcf = fcf_average
    [].tap do |fcfs|
      (1..5).each { |n|
        future_fcf = future_fcf * (1 + growth_rate/100)
        fcfs <<  (future_fcf / (1 + discount_rate) ** n)
      }
      (6..10).each { |n|
        future_fcf = future_fcf * (1 + (growth_rate/2)/100)
        fcfs <<  (future_fcf / (1 + discount_rate) ** n)
      }
    end
  end

  def intrinsic_value
    discounted_value + perpetuity_value
  end

  def price_to_intrinsic_value
    price.divide_by(intrinsic_value.divide_by(issued_shares))
  end

  def discounted_value
    if total_equity > 0
      fcfs.sum + 0.8 * total_equity
    else
      fcfs.sum + total_equity / 0.8
    end
  end

  def perpetuity_value
    future_last_fcf = fcfs.last * ((1 + discount_rate) ** 10)
    (future_last_fcf * 1.05 / (discount_rate - 0.05)) / ((1 + discount_rate) ** 10) #Assuming 5% perpetuity growth rate
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

  def growth_rate
    [profit_growth_rate, 30.0].min
  end

  def eps_growth_rate
    profit_and_losses_for_growth.collect(&:eps).reverse.cagr
  end

  def peg_ratio
    pe_ratio.divide_by(profit_growth_rate)
  end

  def <=> other
    self.score <=> other.score
  end
end
