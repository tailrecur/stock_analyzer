# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :stock_transaction do |f|
  f.type "MyString"
  f.quantity 1
  f.transaction_price 1.5
  f.transaction_date "2011-03-27"
  f.exchange "MyString"
end