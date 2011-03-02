class CashFlow < ActiveRecord::Base
  belongs_to :company, :counter_cache => true

  def operating_cash
    cash_from_operations
  end

  def free_cash
    cash_from_operations + cash_from_investment
  end
end
