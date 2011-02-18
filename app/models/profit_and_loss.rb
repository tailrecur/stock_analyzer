class ProfitAndLoss < ActiveRecord::Base
  belongs_to :company, :counter_cache => true

  def self.latest
    order("period_ended DESC").first
  end
end