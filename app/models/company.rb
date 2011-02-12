class Company < ActiveRecord::Base
  belongs_to :sector

  has_many :balance_sheets, :counter_cache => true
end
