class Company < ActiveRecord::Base
  belongs_to :sector

  has_many :balance_sheets
  has_many :quarterly_results
end
