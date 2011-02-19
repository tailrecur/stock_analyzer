class BalanceSheet < ActiveRecord::Base
  belongs_to :company, :counter_cache => true

  def self.latest
    order("period_ended DESC").first
  end

  def enterprise_value
    company.market_cap + total_debt + preference_share_capital - cash_and_bank_balance
  end

  def net_current_liabilities
    current_liabilities + provisions
  end

  def capital_employed
    total_assets - net_current_liabilities
  end

  def debt_to_equity
    total_debt / total_share_capital unless total_share_capital.zero?
  end
end
