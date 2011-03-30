# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :stock_transaction do |f|
  f.transaction_type StockTransaction::PURCHASE
  f.quantity 3
  f.transaction_price 1.5
  f.transaction_date "2011-03-27"
  f.exchange "NSE"
  f.association :portfolio_stock
end

Factory.define :stock_purchase, :parent => :stock_transaction do |f|
  f.transaction_type StockTransaction::PURCHASE
end

Factory.define :stock_sale, :parent => :stock_transaction do |f|
  f.transaction_type StockTransaction::SALE
end