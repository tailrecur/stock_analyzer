class Company < ActiveRecord::Base
  belongs_to :sector

  has_many :balance_sheets
  has_many :quarterly_results
  has_many :profit_and_losses
end
