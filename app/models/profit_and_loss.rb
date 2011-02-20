class ProfitAndLoss < ActiveRecord::Base
  belongs_to :company, :counter_cache => true
end