class Sector < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  has_many :companies
  memoize :companies

  def self.median_formulae(*formulae)
    formulae.each { |formula|
      define_method(formula) {
        companies.collect(&formula).median
      }
    }
  end

  median_formulae :pe_ratio, :ev_to_sales, :ev_to_ebitda, :roe, :roce, :debt_to_equity_ratio, :price_to_book_value, :peg_ratio
end
