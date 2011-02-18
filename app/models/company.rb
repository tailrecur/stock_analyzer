class Company < ActiveRecord::Base
  belongs_to :sector

  has_many :balance_sheets
  has_many :quarterly_results
  has_many :profit_and_losses

  def eps
    quarterly_results.yearly_latest.collect(&:eps).sum
  end

  def pe_ratio
    price / eps
  end

  def profit_and_loss
    profit_and_losses.latest
  end

  def market_cap
    profit_and_loss.issued_shares * price
  end
end
