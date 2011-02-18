class Sector < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  has_many :companies
  memoize :companies

  def pe_ratio
    companies.collect(&:pe_ratio).average
  end
end
