class BalanceSheet < ActiveRecord::Base
  belongs_to :company, :counter_cache => true

  def enterprise_value
    company.market_cap + total_debt + preference_share_capital - cash_and_bank_balance
  end

  def net_current_liabilities
    current_liabilities + provisions
  end

  def capital_employed
    total_assets - net_current_liabilities
  end

  def debt_to_equity_ratio
    (total_debt + preference_share_capital).divide_by(total_share_capital) * 100
  end

  def debt_to_capital_ratio
    total_debt.divide_by(total_debt + total_share_capital) * 100
  end

  def debt_ratio
    (total_debt + current_liabilities + provisions).divide_by(total_assets - contingent_liabilities) * 100
  end

  def acid_test_ratio
    ((total_current_assets - inventories) + fixed_deposits).divide_by(current_liabilities + provisions) * 100
  end

  def ncavps
    (net_current_assets - total_debt - preference_share_capital).divide_by(company.issued_shares)
  end

  def net_cash
    net_current_assets + investments - total_debt
  end
end
