class Company < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :sector

  has_many :balance_sheets
  has_many :quarterly_results
  has_many :profit_and_losses

  default_scope where(:active => true)

  def profit_and_loss
    profit_and_losses.latest
  end
  memoize :profit_and_loss

  def balance_sheet
    balance_sheets.latest
  end
  memoize :balance_sheet

  def trailing_year_quarters
    quarterly_results.yearly_latest
  end
  memoize :trailing_year_quarters

  def eps
    trailing_year_quarters.collect(&:eps).sum
  end

  def pe_ratio
    price / eps if not eps.zero?
  end

  def market_cap
    profit_and_loss.issued_shares * price
  end

  def yearly_sales
    trailing_year_quarters.collect(&:sales_turnover).sum
  end

  def ev_to_sales
    balance_sheet.enterprise_value / yearly_sales if not yearly_sales.zero?
  end
end
