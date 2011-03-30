class Portfolio < ActiveRecord::Base
  has_many :portfolio_stocks
end
