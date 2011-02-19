class Sector < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  has_many :companies
  memoize :companies

  def pe_ratio
    companies.collect(&:pe_ratio).average
  end

  def ev_to_sales
    companies.collect(&:ev_to_sales).average
  end

  def ev_to_ebitda
    companies.collect(&:ev_to_ebitda).average
  end

  def roe
    companies.collect(&:roe).average
  end
end
