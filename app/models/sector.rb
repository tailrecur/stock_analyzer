class Sector < ActiveRecord::Base
  has_many :companies

  def pe_ratio
    companies.collect(&:pe_ratio).average
  end
end
