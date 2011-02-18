class QuarterlyResult < ActiveRecord::Base

  belongs_to :company, :counter_cache => true

  def self.yearly_latest
    quarters = order("period_ended DESC").limit(4)
    quarters if quarters.length == 4
  end
end
