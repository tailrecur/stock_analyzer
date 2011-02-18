class BalanceSheet < ActiveRecord::Base
  belongs_to :company, :counter_cache => true

  def self.latest
    order("period_ended DESC").first
  end

  def enterprise_value
    company.market_cap + total_debt + preference_share_capital - cash_and_bank_balance
  end
end
