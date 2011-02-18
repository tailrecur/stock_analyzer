class Company < ActiveRecord::Base
  belongs_to :sector

  has_many :balance_sheets
  has_many :quarterly_results
  has_many :profit_and_losses

  def eps
    quarters = quarterly_results[0..3]
    quarters.size < 4 ? -1 : quarters.inject(0) { |sum, quarterly_result| sum + quarterly_result.eps }
  end
end
